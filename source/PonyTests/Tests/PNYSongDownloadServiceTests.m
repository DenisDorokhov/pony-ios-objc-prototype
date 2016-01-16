//
// Created by Denis Dorokhov on 06/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYSongDownloadService.h"
#import "PNYRestServiceImpl.h"
#import "PNYTokenPairDaoMock.h"
#import "PNYPersistentDictionaryMock.h"
#import "PNYAlbumSongsDto.h"

@interface PNYSongDownloadServiceTests : PNYTestCase <PNYSongDownloadServiceDelegate>
{
@private
    PNYRestServiceImpl *restService;
    PNYSongDownloadService *songDownloadService;

    PNYSongDto *downloadingSong;

    BOOL didCallDidStartSongDownload;
    BOOL didCallDidProgressSongDownload;
    BOOL didCallDidCancelSongDownload;
    BOOL didCallDidFailSongDownload;
    BOOL didCallDidCompleteSongDownload;
    BOOL didCallDidDeleteSongDownload;

    float lastProgressValue;

    XCTestExpectation *songDownloadExpectation;
}

@end

@implementation PNYSongDownloadServiceTests

static NSString *const DEMO_URL = @"http://pony.dorokhov.net/demo";
static NSString *const DEMO_EMAIL = @"foo@bar.com";
static NSString *const DEMO_PASSWORD = @"demo";

- (void)setUp
{
    [super setUp];

    id <PNYRestServiceUrlDao> urlDao = mockProtocol(@protocol(PNYRestServiceUrlDao));

    [given([urlDao fetchUrl]) willReturn:[NSURL URLWithString:DEMO_URL]];

    restService = [PNYRestServiceImpl new];
    restService.urlDao = urlDao;
    restService.tokenPairDao = [PNYTokenPairDaoMock new];

    songDownloadService = [PNYSongDownloadService new];
    songDownloadService.restService = restService;
    songDownloadService.persistentDictionary = [PNYPersistentDictionaryMock new];

    [songDownloadService addDelegate:self];

    PNYArtistAlbumsDto *artistAlbums = [self authenticateAndGetArtistAlbumsSynchronously];

    PNYAlbumSongsDto *albumSongs = artistAlbums.albums[0];

    downloadingSong = albumSongs.songs[0];

    didCallDidStartSongDownload = NO;
    didCallDidProgressSongDownload = NO;
    didCallDidCancelSongDownload = NO;
    didCallDidFailSongDownload = NO;
    didCallDidCompleteSongDownload = NO;
    didCallDidDeleteSongDownload = NO;

    lastProgressValue = 0;

    songDownloadExpectation = nil;
}

- (void)tearDown
{
    [songDownloadService removeDelegate:self];

    [super tearDown];
}

- (void)testDownload
{
    songDownloadExpectation = PNYTestExpectationCreate();

    [songDownloadService startDownloadForSong:downloadingSong];

    PNYTestExpectationWait();

    assertThatBool(didCallDidStartSongDownload, isTrue());
    assertThatBool(didCallDidProgressSongDownload, isTrue());
    assertThatBool(didCallDidCancelSongDownload, isFalse());
    assertThatBool(didCallDidFailSongDownload, isFalse());
    assertThatBool(didCallDidCompleteSongDownload, isTrue());
    assertThatBool(didCallDidDeleteSongDownload, isFalse());

    assertThat([songDownloadService progressForSong:downloadingSong.id], nilValue());
    assertThat([songDownloadService allProgresses], isEmpty());

    assertThat([songDownloadService allDownloads], hasCountOf(1));

    id <PNYSongDownload> songDownload = [songDownloadService downloadForSong:downloadingSong.id];

    assertThat(songDownload, notNilValue());

    assertThat(songDownload.songId, equalTo(downloadingSong.id));
    assertThatBool([[NSFileManager defaultManager] fileExistsAtPath:songDownload.filePath], isTrue());
    assertThat(songDownload.date, notNilValue());
}

- (void)testCancellation
{
    songDownloadExpectation = PNYTestExpectationCreate();

    [songDownloadService startDownloadForSong:downloadingSong];
    [songDownloadService cancelDownloadForSong:downloadingSong.id];

    PNYTestExpectationWait();

    assertThatBool(didCallDidStartSongDownload, isTrue());
    assertThatBool(didCallDidCancelSongDownload, isTrue());
    assertThatBool(didCallDidFailSongDownload, isFalse());
    assertThatBool(didCallDidCompleteSongDownload, isFalse());
    assertThatBool(didCallDidDeleteSongDownload, isFalse());

    assertThat([songDownloadService progressForSong:downloadingSong.id], nilValue());
    assertThat([songDownloadService allProgresses], isEmpty());

    assertThat([songDownloadService downloadForSong:downloadingSong.id], nilValue());
    assertThat([songDownloadService allDownloads], isEmpty());
}

- (void)testDeletion
{
    songDownloadExpectation = PNYTestExpectationCreate();

    [songDownloadService startDownloadForSong:downloadingSong];

    PNYTestExpectationWait();

    assertThat([songDownloadService downloadForSong:downloadingSong.id], notNilValue());
    assertThat([songDownloadService allDownloads], hasCountOf(1));

    [songDownloadService deleteDownloadForSong:downloadingSong.id];

    assertThatBool(didCallDidDeleteSongDownload, isTrue());

    assertThat([songDownloadService downloadForSong:downloadingSong.id], nilValue());
    assertThat([songDownloadService allDownloads], isEmpty());
}

#pragma mark - <PNYSongDownloadServiceDelegate>

- (void)songDownloadService:(PNYSongDownloadService *)aService didStartSongDownload:(NSNumber *)aSongId
{
    assertThat(aService, sameInstance(songDownloadService));
    assertThat(aSongId, equalTo(downloadingSong.id));

    didCallDidStartSongDownload = YES;
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didProgressSongDownload:(id <PNYSongDownloadProgress>)aProgress
{
    assertThat(aService, sameInstance(songDownloadService));
    assertThat(aProgress.song, sameInstance(downloadingSong));

    assertThatFloat(aProgress.value, greaterThanOrEqualTo(@(lastProgressValue)));

    lastProgressValue = aProgress.value;

    assertThat([songDownloadService progressForSong:downloadingSong.id], notNilValue());
    assertThat([songDownloadService allProgresses], hasCountOf(1));

    didCallDidProgressSongDownload = YES;
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didCancelSongDownload:(NSNumber *)aSongId
{
    assertThat(aService, sameInstance(songDownloadService));
    assertThat(aSongId, equalTo(downloadingSong.id));

    didCallDidCancelSongDownload = YES;

    [songDownloadExpectation fulfill];
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didFailSongDownload:(NSNumber *)aSongId errors:(NSArray *)aErrors
{
    assertThat(aService, sameInstance(songDownloadService));
    assertThat(aSongId, equalTo(downloadingSong.id));

    didCallDidFailSongDownload = YES;

    [self failExpectation:songDownloadExpectation withErrors:aErrors];
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didCompleteSongDownload:(id <PNYSongDownload>)aSongDownload
{
    assertThat(aService, sameInstance(songDownloadService));
    assertThat(aSongDownload.songId, equalTo(downloadingSong.id));

    didCallDidCompleteSongDownload = YES;

    [songDownloadExpectation fulfill];
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didDeleteSongDownload:(NSNumber *)aSongId
{
    assertThat(aService, sameInstance(songDownloadService));
    assertThat(aSongId, equalTo(downloadingSong.id));

    didCallDidDeleteSongDownload = YES;
}

#pragma mark - Private

- (PNYArtistAlbumsDto *)authenticateAndGetArtistAlbumsSynchronously
{
    NSArray *artists = [self authenticateAndGetArtistsSynchronously];

    assertThat(artists, isNot(isEmpty()));

    PNYArtistDto *albumArtist = artists[0];

    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block PNYArtistAlbumsDto *artistAlbums = nil;

    [restService getArtistAlbumsWithArtist:albumArtist.name success:^(PNYArtistAlbumsDto *aArtistAlbums) {
        [expectation fulfill];
        artistAlbums = aArtistAlbums;
    }                                      failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();

    return artistAlbums;
}

- (NSArray *)authenticateAndGetArtistsSynchronously
{
    [self authenticateSynchronously];

    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block NSArray *artists = nil;

    [restService getArtistsWithSuccess:^(NSArray *aArtists) {
        [expectation fulfill];
        artists = aArtists;
    }                                  failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();

    return artists;
}

- (PNYAuthenticationDto *)authenticateSynchronously
{
    XCTestExpectation *expectation = PNYTestExpectationCreate();

    PNYCredentialsDto *credentials = [PNYCredentialsDto new];

    credentials.email = DEMO_EMAIL;
    credentials.password = DEMO_PASSWORD;

    __block PNYAuthenticationDto *authentication = nil;

    [restService authenticateWithCredentials:credentials success:^(PNYAuthenticationDto *aAuthentication) {

        [expectation fulfill];

        authentication = aAuthentication;

    }                            failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();

    PNYTokenPair *tokenPair = [PNYTokenPair new];

    tokenPair.accessToken = authentication.accessToken;
    tokenPair.accessTokenExpiration = authentication.accessTokenExpiration;

    tokenPair.refreshToken = authentication.refreshToken;
    tokenPair.refreshTokenExpiration = authentication.refreshTokenExpiration;

    [restService.tokenPairDao storeTokenPair:tokenPair];

    return authentication;
}

- (void)failExpectation:(XCTestExpectation *)aExpectation withErrors:(NSArray *)aErrors
{
    [aExpectation fulfill];

    XCTFail(@"Failed with errors: %@.", aErrors);
}

@end