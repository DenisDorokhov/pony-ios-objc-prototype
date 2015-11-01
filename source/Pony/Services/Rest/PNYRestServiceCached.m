//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceCached.h"
#import "PNYRestRequestProxy.h"
#import "PNYMacros.h"

typedef id <PNYRestRequest>(^PNYRestServiceCachedRequestBlock)(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure);

@implementation PNYRestServiceCached

- (instancetype)initWithTargetService:(id <PNYRestService>)aTargetService
{
    self = [super init];
    if (self != nil) {
        _targetService = aTargetService;
    }
    return self;
}

#pragma mark - <PNYRestService>

- (id <PNYRestRequest>)getInstallationWithSuccess:(void (^)(PNYInstallationDto *aInstallation))aSuccess
                                          failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    NSString *cacheKey = @"installation";

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getInstallationWithSuccess:aWrappedSuccess
                                                      failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.installationCache key:cacheKey
                                   success:aSuccess failure:aFailure block:requestBlock];
}

- (id <PNYRestRequest>)authenticate:(PNYCredentialsDto *)aCredentials
                            success:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                            failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    return [self.targetService authenticate:aCredentials success:aSuccess failure:aFailure];
}

- (id <PNYRestRequest>)logoutWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                 failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    return [self.targetService logoutWithSuccess:aSuccess failure:aFailure];
}

- (id <PNYRestRequest>)getCurrentUserWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    NSString *cacheKey = @"currentUser";

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getCurrentUserWithSuccess:aWrappedSuccess
                                                     failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.currentUserCache key:cacheKey
                                   success:aSuccess failure:aFailure block:requestBlock];
}

- (id <PNYRestRequest>)refreshTokenWithSuccess:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                                       failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    return [self.targetService refreshTokenWithSuccess:aSuccess failure:aFailure];
}

- (id <PNYRestRequest>)getArtistsWithSuccess:(void (^)(NSArray *aArtists))aSuccess
                                     failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    NSString *cacheKey = @"artists";

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getArtistsWithSuccess:aWrappedSuccess
                                                 failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.artistsCache key:cacheKey
                                   success:aSuccess failure:aFailure block:requestBlock];
}

- (id <PNYRestRequest>)getArtistAlbums:(NSString *)aArtistIdOrName
                               success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                               failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    NSString *cacheKey = [NSString stringWithFormat:@"artistAlbums.[%@]", aArtistIdOrName];

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getArtistAlbums:aArtistIdOrName
                                           success:aWrappedSuccess
                                           failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.artistAlbumsCache key:cacheKey
                                   success:aSuccess failure:aFailure block:requestBlock];
}

#pragma mark - Private

- (id <PNYRestRequest>)runCachedRequestWithCache:(PNYCacheAsync *)aCache key:(NSString *)aKey success:(PNYRestServiceSuccessBlock)aSuccess failure:(PNYRestServiceFailureBlock)aFailure block:(PNYRestServiceCachedRequestBlock)aBlock
{
    if (aCache != nil) {

        PNYRestRequestProxy *request = [PNYRestRequestProxy new];

        [aCache cachedValueForKey:aKey completion:^(id aCachedValue) {
            if (!request.cancelled) {
                if (aCachedValue != nil) {
                    if (aSuccess != nil) {
                        aSuccess(aCachedValue);
                    }
                } else {
                    request.targetRequest = aBlock(^(id aData) {
                        if (aData != nil) {
                            [aCache cacheValue:aData forKey:aKey completion:^{
                                if (aSuccess != nil) {
                                    aSuccess(aData);
                                }
                            }];
                        }
                    }, aFailure);
                }
            }
        }];

        return request;
    }

    return aBlock(aSuccess, aFailure);
}

@end