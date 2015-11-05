//
// Created by Denis Dorokhov on 03/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYRestServiceCachedImpl.h"
#import "PNYMemoryCache.h"

@interface PNYRestServiceCachedTests : PNYTestCase

@end

@implementation PNYRestServiceCachedTests

- (void)testGetInstallation
{
    id dtoToReturn = [PNYInstallationDto new];

    id <PNYRestService> targetService = mockProtocol(@protocol(PNYRestService));
    [given([targetService getInstallationWithSuccess:anything() failure:anything()]) willDo:^id(NSInvocation *invocation) {
        void (^success)(id) = [invocation mkt_arguments][0];
        success(dtoToReturn);
        return nil;
    }];

    PNYRestServiceCachedImpl *service = [[PNYRestServiceCachedImpl alloc] initWithTargetService:targetService];

    service.installationCache = [PNYCacheAsync cacheWithCache:[PNYMemoryCache new]];

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock) = ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure) {
        [service getInstallationWithSuccess:aSuccess failure:aFailure];
    };

    id dto;

    // Check that first time target service is used.

    dto = [self runMethodAndWait:methodBlock];
    assertThat(dto, sameInstance(dtoToReturn));

    [verify(targetService) getInstallationWithSuccess:anything() failure:anything()];

    // Check that second time cache is used and target service is not called.

    dto = [self runMethodAndWait:methodBlock];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(1)) getInstallationWithSuccess:anything() failure:anything()];

    // Check cache value existence.

    assertThatBool([self cachedValueExistsForBlock:^(void(^aCompletion)(BOOL)) {
        [service cachedValueExistsForInstallation:aCompletion];
    }], isTrue());
}

- (void)testAuthenticate
{
    id dtoToReturn = [PNYAuthenticationDto new];

    id <PNYRestService> targetService = mockProtocol(@protocol(PNYRestService));
    [given([targetService authenticateWithCredentials:anything() success:anything() failure:anything()]) willDo:^id(NSInvocation *invocation) {
        void (^success)(id) = [invocation mkt_arguments][1];
        success(dtoToReturn);
        return nil;
    }];

    PNYRestServiceCachedImpl *service = [[PNYRestServiceCachedImpl alloc] initWithTargetService:targetService];

    // Check that target service is used.

    id dto = [self runMethodAndWait:^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure) {
        [service authenticateWithCredentials:nil success:aSuccess failure:aFailure];
    }];
    assertThat(dto, sameInstance(dtoToReturn));
}

- (void)testLogout
{
    id dtoToReturn = [PNYUserDto new];

    id <PNYRestService> targetService = mockProtocol(@protocol(PNYRestService));
    [given([targetService logoutWithSuccess:anything() failure:anything()]) willDo:^id(NSInvocation *invocation) {
        void (^success)(id) = [invocation mkt_arguments][0];
        success(dtoToReturn);
        return nil;
    }];

    PNYRestServiceCachedImpl *service = [[PNYRestServiceCachedImpl alloc] initWithTargetService:targetService];

    // Check that target service is used.

    id dto = [self runMethodAndWait:^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure) {
        [service logoutWithSuccess:aSuccess failure:aFailure];
    }];
    assertThat(dto, sameInstance(dtoToReturn));
}

- (void)testGetCurrentUser
{
    id dtoToReturn = [PNYUserDto new];

    id <PNYRestService> targetService = mockProtocol(@protocol(PNYRestService));
    [given([targetService getCurrentUserWithSuccess:anything() failure:anything()]) willDo:^id(NSInvocation *invocation) {
        void (^success)(id) = [invocation mkt_arguments][0];
        success(dtoToReturn);
        return nil;
    }];

    PNYRestServiceCachedImpl *service = [[PNYRestServiceCachedImpl alloc] initWithTargetService:targetService];

    service.currentUserCache = [PNYCacheAsync cacheWithCache:[PNYMemoryCache new]];

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock) = ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure) {
        [service getCurrentUserWithSuccess:aSuccess failure:aFailure];
    };

    id dto;

    // Check that first time target service is used.

    dto = [self runMethodAndWait:methodBlock];
    assertThat(dto, sameInstance(dtoToReturn));

    [verify(targetService) getCurrentUserWithSuccess:anything() failure:anything()];

    // Check that second time cache is used and target service is not called.

    dto = [self runMethodAndWait:methodBlock];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(1)) getCurrentUserWithSuccess:anything() failure:anything()];

    // Check cache value existence.

    assertThatBool([self cachedValueExistsForBlock:^(void(^aCompletion)(BOOL)) {
        [service cachedValueExistsForCurrentUser:aCompletion];
    }], isTrue());
}

- (void)testRefreshToken
{
    id dtoToReturn = [PNYAuthenticationDto new];

    id <PNYRestService> targetService = mockProtocol(@protocol(PNYRestService));
    [given([targetService refreshTokenWithSuccess:anything() failure:anything()]) willDo:^id(NSInvocation *invocation) {
        void (^success)(id) = [invocation mkt_arguments][0];
        success(dtoToReturn);
        return nil;
    }];

    PNYRestServiceCachedImpl *service = [[PNYRestServiceCachedImpl alloc] initWithTargetService:targetService];

    // Check that target service is used.

    id dto = [self runMethodAndWait:^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure) {
        [service refreshTokenWithSuccess:aSuccess failure:aFailure];
    }];
    assertThat(dto, sameInstance(dtoToReturn));
}

- (void)testGetArtists
{
    id dtoToReturn = [NSArray new];

    id <PNYRestService> targetService = mockProtocol(@protocol(PNYRestService));
    [given([targetService getArtistsWithSuccess:anything() failure:anything()]) willDo:^id(NSInvocation *invocation) {
        void (^success)(id) = [invocation mkt_arguments][0];
        success(dtoToReturn);
        return nil;
    }];

    PNYRestServiceCachedImpl *service = [[PNYRestServiceCachedImpl alloc] initWithTargetService:targetService];

    service.artistsCache = [PNYCacheAsync cacheWithCache:[PNYMemoryCache new]];

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock) = ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure) {
        [service getArtistsWithSuccess:aSuccess failure:aFailure];
    };

    id dto;

    // Check that first time target service is used.

    dto = [self runMethodAndWait:methodBlock];
    assertThat(dto, sameInstance(dtoToReturn));

    [verify(targetService) getArtistsWithSuccess:anything() failure:anything()];

    // Check that second time cache is used and target service is not called.

    dto = [self runMethodAndWait:methodBlock];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(1)) getArtistsWithSuccess:anything() failure:anything()];

    // Check cache value existence.

    assertThatBool([self cachedValueExistsForBlock:^(void(^aCompletion)(BOOL)) {
        [service cachedValueExistsForArtists:aCompletion];
    }], isTrue());
}

- (void)testGetArtistAlbums
{
    id dtoToReturn = [PNYArtistAlbumsDto new];

    id <PNYRestService> targetService = mockProtocol(@protocol(PNYRestService));
    [given([targetService getArtistAlbumsWithArtist:@"someArtist" success:anything() failure:anything()]) willDo:^id(NSInvocation *invocation) {
        void (^success)(id) = [invocation mkt_arguments][1];
        success(dtoToReturn);
        return nil;
    }];

    PNYRestServiceCachedImpl *service = [[PNYRestServiceCachedImpl alloc] initWithTargetService:targetService];

    service.artistAlbumsCache = [PNYCacheAsync cacheWithCache:[PNYMemoryCache new]];

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock) = ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure) {
        [service getArtistAlbumsWithArtist:@"someArtist" success:aSuccess failure:aFailure];
    };

    id dto;

    // Check that first time target service is used.

    dto = [self runMethodAndWait:methodBlock];
    assertThat(dto, sameInstance(dtoToReturn));

    [verify(targetService) getArtistAlbumsWithArtist:@"someArtist" success:anything() failure:anything()];

    // Check that second time cache is used and target service is not called.

    dto = [self runMethodAndWait:methodBlock];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(1)) getArtistAlbumsWithArtist:@"someArtist" success:anything() failure:anything()];

    // Check cache value existence.

    assertThatBool([self cachedValueExistsForBlock:^(void(^aCompletion)(BOOL)) {
        [service cachedValueExistsForArtistAlbums:@"someArtist" completion:aCompletion];
    }], isTrue());
}

#pragma mark - Private

- (id)runMethodAndWait:(void (^)(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure))aBlock
{
    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block PNYInstallationDto *returnedDto = nil;
    aBlock(^(PNYInstallationDto *aInstallation) {
        returnedDto = aInstallation;
        [expectation fulfill];
    }, ^(NSArray *aErrors) {
        [expectation fulfill];
        XCTFail(@"Failed with errors: %@.", aErrors);
    });

    PNYTestExpectationWait();

    return returnedDto;
}

- (BOOL)cachedValueExistsForBlock:(void(^)(void(^Completion)(BOOL)))aBlock
{
    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block BOOL result = NO;
    aBlock(^(BOOL aCompletion) {
        result = aCompletion;
        [expectation fulfill];
    });

    PNYTestExpectationWait();

    return result;
}

@end