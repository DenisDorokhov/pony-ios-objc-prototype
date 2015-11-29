//
// Created by Denis Dorokhov on 03/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYRestServiceCachedImpl.h"
#import "PNYMemoryCache.h"
#import "PNYTestUtils.h"
#import "PNYSongDto.h"

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

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock, BOOL) =
            ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, BOOL aUseCache) {
                [service getInstallationWithSuccess:aSuccess failure:aFailure useCache:aUseCache];
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

    // Check that target service is used  when useCache is NO.

    dto = [self runMethodAndWait:methodBlock useCache:NO];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(2)) getInstallationWithSuccess:anything() failure:anything()];

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

    id dto = [self runMethodAndWait:^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, BOOL aUseCache) {
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

    id dto = [self runMethodAndWait:^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, BOOL aUseCache) {
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

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock, BOOL) =
            ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, BOOL aUseCache) {
                [service getCurrentUserWithSuccess:aSuccess failure:aFailure useCache:aUseCache];
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

    // Check that target service is used  when useCache is NO.

    dto = [self runMethodAndWait:methodBlock useCache:NO];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(2)) getCurrentUserWithSuccess:anything() failure:anything()];

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

    id dto = [self runMethodAndWait:^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, BOOL aUseCache) {
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

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock, BOOL) =
            ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, BOOL aUseCache) {
                [service getArtistsWithSuccess:aSuccess failure:aFailure useCache:aUseCache];
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

    // Check that target service is used  when useCache is NO.

    dto = [self runMethodAndWait:methodBlock useCache:NO];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(2)) getArtistsWithSuccess:anything() failure:anything()];

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

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock, BOOL) =
            ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, BOOL aUseCache) {
                [service getArtistAlbumsWithArtist:@"someArtist" success:aSuccess failure:aFailure useCache:aUseCache];
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

    // Check that target service is used  when useCache is NO.

    dto = [self runMethodAndWait:methodBlock useCache:NO];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(2)) getArtistAlbumsWithArtist:@"someArtist" success:anything() failure:anything()];

    // Check cache value existence.

    assertThatBool([self cachedValueExistsForBlock:^(void(^aCompletion)(BOOL)) {
        [service cachedValueExistsForArtistAlbums:@"someArtist" completion:aCompletion];
    }], isTrue());
}

- (void)testGetSongs
{
    id dtoToReturn = @[[PNYSongDto new]];

    id <PNYRestService> targetService = mockProtocol(@protocol(PNYRestService));
    [given([targetService getSongsWithIds:anything() success:anything() failure:anything()]) willDo:^id(NSInvocation *invocation) {
        void (^success)(id) = [invocation mkt_arguments][1];
        success(dtoToReturn);
        return nil;
    }];

    PNYRestServiceCachedImpl *service = [[PNYRestServiceCachedImpl alloc] initWithTargetService:targetService];

    // Check that target service is used.

    id dto = [self runMethodAndWait:^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, BOOL aUseCache) {
        [service getSongsWithIds:nil success:aSuccess failure:aFailure];
    }];
    assertThat(dto, sameInstance(dtoToReturn));
}

- (void)testDownloadImage
{
    UIImage *imageToReturn = [PNYTestUtils generateImageWithSize:CGSizeMake(10, 10)];

    id <PNYRestService> targetService = mockProtocol(@protocol(PNYRestService));
    [given([targetService downloadImage:@"someUrl" success:anything() failure:anything()]) willDo:^id(NSInvocation *invocation) {
        void (^success)(id) = [invocation mkt_arguments][1];
        success(imageToReturn);
        return nil;
    }];

    PNYRestServiceCachedImpl *service = [[PNYRestServiceCachedImpl alloc] initWithTargetService:targetService];

    service.imageCache = [PNYCacheAsync cacheWithCache:[PNYMemoryCache new]];

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock, BOOL) =
            ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, BOOL aUseCache) {
                [service downloadImage:@"someUrl" success:aSuccess failure:aFailure useCache:aUseCache];
            };

    UIImage *image;

    // Check that first time target service is used.

    image = [self runMethodAndWait:methodBlock];
    assertThat(image, sameInstance(imageToReturn));

    [verify(targetService) downloadImage:@"someUrl" success:anything() failure:anything()];

    // Check that second time cache is used and target service is not called.

    image = [self runMethodAndWait:methodBlock];
    assertThat(image, sameInstance(imageToReturn));

    [verifyCount(targetService, times(1)) downloadImage:@"someUrl" success:anything() failure:anything()];

    // Check that target service is used  when useCache is NO.

    image = [self runMethodAndWait:methodBlock useCache:NO];
    assertThat(image, sameInstance(imageToReturn));

    [verifyCount(targetService, times(2)) downloadImage:@"someUrl" success:anything() failure:anything()];

    // Check cache value existence.

    assertThatBool([self cachedValueExistsForBlock:^(void(^aCompletion)(BOOL)) {
        [service cachedValueExistsForImage:@"someUrl" completion:aCompletion];
    }], isTrue());
}

- (void)testDownloadSong
{
    id <PNYRestService> targetService = mockProtocol(@protocol(PNYRestService));
    [given([targetService downloadSongWithId:anything() toFile:anything()
                                    progress:anything()
                                     success:anything()
                                     failure:anything()]) willDo:^id(NSInvocation *invocation) {
        void (^success)() = [invocation mkt_arguments][3];
        success();
        return nil;
    }];

    PNYRestServiceCachedImpl *service = [[PNYRestServiceCachedImpl alloc] initWithTargetService:targetService];

    // Check that target service is used.

    XCTestExpectation *expectation = PNYTestExpectationCreate();

    [service downloadSongWithId:@123 toFile:@"somePath" progress:nil success:^{
        [expectation fulfill];
    } failure:^(NSArray *aErrors) {
        [expectation fulfill];
        XCTFail(@"Failed with errors: %@.", aErrors);
    }];

    PNYTestExpectationWait();

    [verify(targetService) downloadSongWithId:@123 toFile:@"somePath" progress:nil success:anything() failure:anything()];
}

#pragma mark - Private

- (id)runMethodAndWait:(void (^)(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, BOOL aUseCache))aBlock
{
    return [self runMethodAndWait:aBlock useCache:YES];
}

- (id)runMethodAndWait:(void (^)(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, BOOL aUseCache))aBlock useCache:(BOOL)aUseCache
{
    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block PNYInstallationDto *returnedDto = nil;
    aBlock(^(id aResult) {
        returnedDto = aResult;
        [expectation fulfill];
    }, ^(NSArray *aErrors) {
        [expectation fulfill];
        XCTFail(@"Failed with errors: %@.", aErrors);
    }, aUseCache);

    PNYTestExpectationWait();

    return returnedDto;
}

- (BOOL)cachedValueExistsForBlock:(void (^)(void(^Completion)(BOOL)))aBlock
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