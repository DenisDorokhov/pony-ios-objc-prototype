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

static NSString *const SERVICE_URL = @"http://pony.dorokhov.net/demo";

- (void)setUp
{
    [super setUp];

    PNYTokenPairDaoImpl *tokenPairDao = [[PNYTokenPairDaoImpl alloc] init];
    tokenPairDao.persistentDictionary = [[PNYPersistentDictionaryImpl alloc] init];

    service = [[PNYRestServiceImpl alloc] init];
    service.urlProvider = [PNYRestServiceUrlProviderMock serviceUrlProviderWithUrlToReturn:SERVICE_URL];
    service.tokenPairDao = tokenPairDao;
}

- (void)testGetInstallation
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"getInstallation"];

    [service getInstallationWithSuccess:^(PNYInstallationDto *aInstallation) {

        XCTAssertNotNil(aInstallation);

        [expectation fulfill];

    } failure:^(NSArray *aErrors) {

        XCTFail(@"%@", aErrors);

        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testAuthenticate
{
    XCTFail();
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

@end