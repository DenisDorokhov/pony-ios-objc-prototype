//
// Created by Denis Dorokhov on 25/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYRestServiceImpl.h"
#import "PNYAlbumDto.h"
#import "PNYAlbumSongsDto.h"
#import "PNYSongDto.h"
#import "PNYTokenPairDaoMock.h"

@interface PNYRestServiceTests : PNYTestCase
{
@private
    PNYRestServiceImpl *service;
}

@end

@implementation PNYRestServiceTests

static NSString *const DEMO_URL = @"http://pony.dorokhov.net/demo";
static NSString *const DEMO_EMAIL = @"foo@bar.com";
static NSString *const DEMO_PASSWORD = @"demo";

- (void)setUp
{
    [super setUp];

    id <PNYRestServiceUrlProvider> urlProvider = mockProtocol(@protocol(PNYRestServiceUrlProvider));

    [given([urlProvider serverUrl]) willReturn:[NSURL URLWithString:DEMO_URL]];

    service = [PNYRestServiceImpl new];
    service.urlProvider = urlProvider;
    service.tokenPairDao = [PNYTokenPairDaoMock new];
}

- (void)testGetInstallation
{
    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block PNYInstallationDto *installation = nil;

    [service getInstallationWithSuccess:^(PNYInstallationDto *aInstallation) {

        [expectation fulfill];

        installation = aInstallation;

    } failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();

    XCTAssertNotNil(installation.version);
}

- (void)testAuthenticate
{
    [self assertDemoAuthentication:[self authenticateSynchronously]];
}

- (void)testLogout
{
    [self authenticateSynchronously];

    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block PNYUserDto *user = nil;

    [service logoutWithSuccess:^(PNYUserDto *aUser) {

        [expectation fulfill];

        user = aUser;

    } failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();

    [self assertDemoUser:user];
}

- (void)testGetCurrentUser
{
    [self authenticateSynchronously];

    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block PNYUserDto *user = nil;

    [service getCurrentUserWithSuccess:^(PNYUserDto *aUser) {

        [expectation fulfill];

        user = aUser;

    } failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();

    [self assertDemoUser:user];
}

- (void)testRefreshToken
{
    [self authenticateSynchronously];

    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block PNYAuthenticationDto *authentication = nil;

    [service refreshTokenWithSuccess:^(PNYAuthenticationDto *aAuthentication) {

        [expectation fulfill];

        authentication = aAuthentication;

    } failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();

    [self assertDemoAuthentication:authentication];
}

- (void)testGetArtists
{
    NSArray *artists = [self authenticateAndGetArtistsSynchronously];

    XCTAssertGreaterThan([artists count], 0);

    PNYArtistDto *artist = artists[0];

    [self assertArtist:artist];
}

- (void)testGetArtistAlbums
{
    NSArray *artists = [self authenticateAndGetArtistsSynchronously];

    XCTAssertGreaterThan([artists count], 0);

    PNYArtistDto *albumArtist = artists[0];

    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block PNYArtistAlbumsDto *artistAlbums = nil;

    [service getArtistAlbumsWithArtist:albumArtist.name success:^(PNYArtistAlbumsDto *aArtistAlbums) {

        [expectation fulfill];

        artistAlbums = aArtistAlbums;

    }                          failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();

    XCTAssertNotNil(artistAlbums.artist);
    XCTAssertGreaterThan([artistAlbums.albums count], 0);

    [self assertArtist:artistAlbums.artist];
    [self assertAlbumSongs:artistAlbums.albums[0]];
}

#pragma mark - Private

- (NSArray *)authenticateAndGetArtistsSynchronously
{
    [self authenticateSynchronously];

    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block NSArray *artists = nil;

    [service getArtistsWithSuccess:^(NSArray *aArtists) {

        [expectation fulfill];

        artists = aArtists;

    } failure:^(NSArray *aErrors) {
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

    [service authenticateWithCredentials:credentials success:^(PNYAuthenticationDto *aAuthentication) {

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

    [service.tokenPairDao storeTokenPair:tokenPair];

    return authentication;
}

- (void)failExpectation:(XCTestExpectation *)aExpectation withErrors:(NSArray *)aErrors
{
    [aExpectation fulfill];

    XCTFail(@"Failed with errors: %@.", aErrors);
}

- (void)assertDemoAuthentication:(PNYAuthenticationDto *)aAuthentication
{
    XCTAssertNotNil(aAuthentication.accessToken);
    XCTAssertNotNil(aAuthentication.accessTokenExpiration);
    XCTAssertNotNil(aAuthentication.refreshToken);
    XCTAssertNotNil(aAuthentication.refreshTokenExpiration);

    [self assertDemoUser:aAuthentication.user];
}

- (void)assertDemoUser:(PNYUserDto *)aUser
{
    XCTAssertNotNil(aUser.name);
    XCTAssertEqualObjects(aUser.email, DEMO_EMAIL);
    XCTAssertNotNil(aUser.creationDate);
    XCTAssertEqual(aUser.role, PNYRoleDtoUser);
}

- (void)assertArtist:(PNYArtistDto *)aArtist
{
    XCTAssertNotNil(aArtist.id);
    XCTAssertNotNil(aArtist.name);
    XCTAssertNotNil(aArtist.artwork);
    XCTAssertNotNil(aArtist.artworkUrl);
}

- (void)assertAlbum:(PNYAlbumDto *)aAlbum
{
    XCTAssertNotNil(aAlbum.id);
    XCTAssertNotNil(aAlbum.name);
    XCTAssertNotNil(aAlbum.year);
    XCTAssertNotNil(aAlbum.artwork);
    XCTAssertNotNil(aAlbum.artworkUrl);

    [self assertArtist:aAlbum.artist];
}

- (void)assertGenre:(PNYGenreDto *)aGenre
{
    XCTAssertNotNil(aGenre.id);
    XCTAssertNotNil(aGenre.name);
    XCTAssertNotNil(aGenre.artwork);
    XCTAssertNotNil(aGenre.artworkUrl);
}

- (void)assertSong:(PNYSongDto *)aSong
{
    // Disc number can be nil, so we skip it.

    XCTAssertNotNil(aSong.id);
    XCTAssertNotNil(aSong.url);
    XCTAssertNotNil(aSong.duration);
    XCTAssertNotNil(aSong.trackNumber);
    XCTAssertNotNil(aSong.artistName);
    XCTAssertNotNil(aSong.name);

    [self assertAlbum:aSong.album];
    [self assertGenre:aSong.genre];
}

- (void)assertAlbumSongs:(PNYAlbumSongsDto *)aAlbumSongs
{
    [self assertAlbum:aAlbumSongs.album];

    XCTAssertGreaterThan([aAlbumSongs.songs count], 0);

    [self assertSong:aAlbumSongs.songs[0]];
}

@end