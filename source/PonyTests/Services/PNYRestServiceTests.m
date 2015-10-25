//
// Created by Denis Dorokhov on 25/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYRestServiceImpl.h"
#import "PNYRestServiceUrlProviderMock.h"
#import "PNYTokenPairDaoImpl.h"
#import "PNYPersistentDictionaryImpl.h"
#import "PNYFileUtils.h"

@interface PNYRestServiceTests : PNYTestCase
{
@private
    PNYRestServiceImpl *service;
    PNYTokenPairDaoImpl *tokenPairDao;
}

@end

@implementation PNYRestServiceTests

static NSString *const DEMO_URL = @"http://pony.dorokhov.net/demo";
static NSString *const DEMO_EMAIL = @"foo@bar.com";
static NSString *const DEMO_PASSWORD = @"demo";

- (void)setUp
{
    [super setUp];

    NSString *persistenceFilePath = [PNYFileUtils filePathInDocuments:@"PNYRestServiceTests"];

    tokenPairDao = [[PNYTokenPairDaoImpl alloc] init];
    tokenPairDao.persistentDictionary = [[PNYPersistentDictionaryImpl alloc] initWithFilePath:persistenceFilePath];

    service = [[PNYRestServiceImpl alloc] init];
    service.urlProvider = [PNYRestServiceUrlProviderMock serviceUrlProviderWithUrlToReturn:DEMO_URL];
    service.tokenPairDao = tokenPairDao;
}

- (void)testGetInstallation
{
    XCTestExpectation *expectation = PNYTestExpectationCreate();

    [service getInstallationWithSuccess:^(PNYInstallationDto *aInstallation) {

        [expectation fulfill];

        XCTAssertNotNil(aInstallation.version);

    } failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();
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

    // TODO: assert artists
}

- (void)testGetArtistAlbums
{
    NSArray *artists = [self authenticateAndGetArtistsSynchronously];

    XCTAssertGreaterThan([artists count], 0);

    PNYArtistDto *albumArtist = artists[0];

    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block PNYArtistAlbumsDto *artistAlbums = nil;

    [service getArtistAlbums:albumArtist.name success:^(PNYArtistAlbumsDto *aArtistAlbums) {

        [expectation fulfill];

        artistAlbums = aArtistAlbums;

    } failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();

    XCTAssertNotNil(artistAlbums.artist);
    XCTAssertGreaterThan([artistAlbums.albums count], 0);

    // TODO: assert artist albums
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

    PNYCredentialsDto *credentials = [[PNYCredentialsDto alloc] init];

    credentials.email = DEMO_EMAIL;
    credentials.password = DEMO_PASSWORD;

    __block PNYAuthenticationDto *authentication = nil;

    [service authenticate:credentials success:^(PNYAuthenticationDto *aAuthentication) {

        [expectation fulfill];

        authentication = aAuthentication;

    }             failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();

    PNYTokenPair *tokenPair = [[PNYTokenPair alloc] init];

    tokenPair.accessToken = authentication.accessToken;
    tokenPair.accessTokenExpiration = authentication.accessTokenExpiration;

    tokenPair.refreshToken = authentication.refreshToken;
    tokenPair.refreshTokenExpiration = authentication.refreshTokenExpiration;

    [tokenPairDao storeTokenPair:tokenPair];

    return authentication;
}

- (void)failExpectation:(XCTestExpectation *)aExpectation withErrors:(NSArray *)aErrors
{
    [aExpectation fulfill];

    XCTFail(@"Request failed with errors: %@", aErrors);
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

@end