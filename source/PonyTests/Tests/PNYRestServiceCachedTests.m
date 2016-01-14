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

    service.installationCache = [PNYCacheAsync cacheWithAsynchronousCache:[PNYMemoryCache new]];

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock, PNYRestServiceCacheHandlerBlock) =
            ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, PNYRestServiceCacheHandlerBlock aCacheHandler) {
                [service getInstallationWithSuccess:aSuccess failure:aFailure cacheHandler:aCacheHandler];
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

    // Check that target service is not called when cache handler is nil.

    dto = [self runMethodAndWait:methodBlock useNilCacheHandler:YES];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(2)) getInstallationWithSuccess:anything() failure:anything()];
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

    id dto = [self runMethodAndWait:^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, PNYRestServiceCacheHandlerBlock aCacheHandler) {
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

    id dto = [self runMethodAndWait:^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, PNYRestServiceCacheHandlerBlock aCacheHandler) {
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

    service.currentUserCache = [PNYCacheAsync cacheWithAsynchronousCache:[PNYMemoryCache new]];

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock, PNYRestServiceCacheHandlerBlock) =
            ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, PNYRestServiceCacheHandlerBlock aCacheHandler) {
                [service getCurrentUserWithSuccess:aSuccess failure:aFailure cacheHandler:aCacheHandler];
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

    // Check that target service is not called when cache handler is nil.

    dto = [self runMethodAndWait:methodBlock useNilCacheHandler:YES];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(2)) getCurrentUserWithSuccess:anything() failure:anything()];
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

    id dto = [self runMethodAndWait:^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, PNYRestServiceCacheHandlerBlock aCacheHandler) {
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

    service.artistsCache = [PNYCacheAsync cacheWithAsynchronousCache:[PNYMemoryCache new]];

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock, PNYRestServiceCacheHandlerBlock) =
            ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, PNYRestServiceCacheHandlerBlock aCacheHandler) {
                [service getArtistsWithSuccess:aSuccess failure:aFailure cacheHandler:aCacheHandler];
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

    // Check that target service is not called when cache handler is nil.

    dto = [self runMethodAndWait:methodBlock useNilCacheHandler:YES];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(2)) getArtistsWithSuccess:anything() failure:anything()];
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

    service.artistAlbumsCache = [PNYCacheAsync cacheWithAsynchronousCache:[PNYMemoryCache new]];

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock, PNYRestServiceCacheHandlerBlock) =
            ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, PNYRestServiceCacheHandlerBlock aCacheHandler) {
                [service getArtistAlbumsWithArtist:@"someArtist" success:aSuccess failure:aFailure cacheHandler:aCacheHandler];
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

    // Check that target service is not called when cache handler is nil.

    dto = [self runMethodAndWait:methodBlock useNilCacheHandler:YES];
    assertThat(dto, sameInstance(dtoToReturn));

    [verifyCount(targetService, times(2)) getArtistAlbumsWithArtist:@"someArtist" success:anything() failure:anything()];
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

    id dto = [self runMethodAndWait:^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, PNYRestServiceCacheHandlerBlock aCacheHandler) {
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

    service.imageCache = [PNYCacheAsync cacheWithAsynchronousCache:[PNYMemoryCache new]];

    void (^methodBlock)(PNYRestServiceSuccessBlock, PNYRestServiceFailureBlock, PNYRestServiceCacheHandlerBlock) =
            ^(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, PNYRestServiceCacheHandlerBlock aCacheHandler) {
                [service downloadImage:@"someUrl" success:aSuccess failure:aFailure cacheHandler:aCacheHandler];
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

    // Check that target service is not called when cache handler is nil.

    image = [self runMethodAndWait:methodBlock useNilCacheHandler:YES];
    assertThat(image, sameInstance(imageToReturn));

    [verifyCount(targetService, times(2)) downloadImage:@"someUrl" success:anything() failure:anything()];
}

- (void)testDownloadSong
{
    id <PNYRestService> targetService = mockProtocol(@protocol(PNYRestService));
    [given([targetService downloadSong:anything() toFile:anything()
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

    [service downloadSong:@"someUrl" toFile:@"somePath" progress:nil success:^{
        [expectation fulfill];
    }             failure:^(NSArray *aErrors) {
        [expectation fulfill];
        XCTFail(@"Failed with errors: %@.", aErrors);
    }];

    PNYTestExpectationWait();

    [verify(targetService) downloadSong:@"someUrl" toFile:@"somePath" progress:nil success:anything() failure:anything()];
}

#pragma mark - Private

- (id)runMethodAndWait:(void (^)(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, PNYRestServiceCacheHandlerBlock aCacheHandler))aBlock
{
    return [self runMethodAndWait:aBlock useNilCacheHandler:NO];
}

- (id)runMethodAndWait:(void (^)(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure, PNYRestServiceCacheHandlerBlock aCacheHandler))aBlock
    useNilCacheHandler:(BOOL)aUseNilCacheHandler
{
    XCTestExpectation *expectation = PNYTestExpectationCreate();

    __block PNYInstallationDto *returnedDto = nil;
    aBlock(^(id aResult) {
        returnedDto = aResult;
        [expectation fulfill];
    }, ^(NSArray *aErrors) {
        [expectation fulfill];
        XCTFail(@"Failed with errors: %@.", aErrors);
    }, aUseNilCacheHandler ? nil : ^BOOL (id aCachedValue) {
        returnedDto = aCachedValue;
        if (aCachedValue != nil) {
            [expectation fulfill];
        }
        return aCachedValue == nil;
    });

    PNYTestExpectationWait();

    return returnedDto;
}

@end