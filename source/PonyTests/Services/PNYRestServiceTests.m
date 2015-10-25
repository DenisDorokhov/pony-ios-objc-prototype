//
// Created by Denis Dorokhov on 25/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYRestServiceImpl.h"
#import "PNYRestServiceUrlProviderMock.h"
#import "PNYTokenPairDaoImpl.h"
#import "PNYPersistentDictionaryImpl.h"

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

    PNYTokenPairDaoImpl *tokenPairDao = [[PNYTokenPairDaoImpl alloc] init];
    tokenPairDao.persistentDictionary = [[PNYPersistentDictionaryImpl alloc] init];

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
    XCTestExpectation *expectation = PNYTestExpectationCreate();

    PNYCredentialsDto *credentials = [[PNYCredentialsDto alloc] init];

    credentials.email = DEMO_EMAIL;
    credentials.password = DEMO_PASSWORD;

    [service authenticate:credentials success:^(PNYAuthenticationDto *aAuthentication) {

        [expectation fulfill];

        XCTAssertNotNil(aAuthentication.accessToken);
        XCTAssertNotNil(aAuthentication.accessTokenExpiration);
        XCTAssertNotNil(aAuthentication.refreshToken);
        XCTAssertNotNil(aAuthentication.refreshTokenExpiration);

        XCTAssertNotNil(aAuthentication.user.name);
        XCTAssertNotNil(aAuthentication.user.email);
        XCTAssertNotNil(aAuthentication.user.creationDate);
        XCTAssertNotNil(aAuthentication.user.updateDate);
        XCTAssertEqual(aAuthentication.user.role, PNYRoleDtoUser);

    } failure:^(NSArray *aErrors) {
        [self failExpectation:expectation withErrors:aErrors];
    }];

    PNYTestExpectationWait();
}

- (void)testLogout
{
    XCTFail();
}

- (void)testGetCurrentUser
{
    XCTFail();
}

- (void)testRefreshToken
{
    XCTFail();
}

- (void)testGetArtists
{
    XCTFail();
}

- (void)testGetArtistAlbums
{
    XCTFail();
}

#pragma mark - Private

- (void)failExpectation:(XCTestExpectation *)aExpectation withErrors:(NSArray *)aErrors
{
    [aExpectation fulfill];

    XCTFail(@"Request failed with errors: %@", aErrors);
}

@end