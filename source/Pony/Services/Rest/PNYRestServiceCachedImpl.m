//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceCachedImpl.h"
#import "PNYRestRequestProxy.h"
#import "PNYMacros.h"
#import "PNYErrorDto.h"

typedef id <PNYRestRequest>(^PNYRestServiceCachedRequestBlock)(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure);

@implementation PNYRestServiceCachedImpl

static NSString *const KEY_INSTALLATION = @"installation";
static NSString *const KEY_CURRENT_USER = @"currentUser";
static NSString *const KEY_ARTISTS = @"artists";
static NSString *const KEY_ARTIST_ALBUMS = @"artistAlbums:%@";
static NSString *const KEY_IMAGES = @"images:%@";

- (instancetype)initWithTargetService:(id <PNYRestService>)aTargetService
{
    self = [super init];
    if (self != nil) {
        _targetService = aTargetService;
    }
    return self;
}

#pragma mark - <PNYRestServiceCached>

- (void)cachedValueExistsForInstallation:(void (^)(BOOL aCachedValueExists))aCompletion
{
    if (self.installationCache != nil) {
        [self.installationCache cachedValueExistsForKey:KEY_INSTALLATION completion:aCompletion];
    } else {
        if (aCompletion != nil) {
            aCompletion(NO);
        }
    }
}

- (void)cachedValueExistsForCurrentUser:(void (^)(BOOL aCachedValueExists))aCompletion
{
    if (self.currentUserCache != nil) {
        [self.currentUserCache cachedValueExistsForKey:KEY_CURRENT_USER completion:aCompletion];
    } else {
        if (aCompletion != nil) {
            aCompletion(NO);
        }
    }
}

- (void)cachedValueExistsForArtists:(void (^)(BOOL aCachedValueExists))aCompletion
{
    if (self.artistsCache != nil) {
        [self.artistsCache cachedValueExistsForKey:KEY_ARTISTS completion:aCompletion];
    } else {
        if (aCompletion != nil) {
            aCompletion(NO);
        }
    }
}

- (void)cachedValueExistsForArtistAlbums:(NSString *)aArtistIdOrName completion:(void (^)(BOOL aCachedValueExists))aCompletion
{
    if (self.artistAlbumsCache != nil) {

        NSString *cacheKey = [NSString stringWithFormat:KEY_ARTIST_ALBUMS, aArtistIdOrName];

        [self.artistAlbumsCache cachedValueExistsForKey:cacheKey completion:aCompletion];

    } else {
        if (aCompletion != nil) {
            aCompletion(NO);
        }
    }
}

- (void)cachedValueExistsForImage:(NSString *)aAbsoluteUrl completion:(void (^)(BOOL aCachedValueExists))aCompletion
{
    if (self.imageCache != nil) {

        NSString *cacheKey = [NSString stringWithFormat:KEY_IMAGES, aAbsoluteUrl];

        [self.imageCache cachedValueExistsForKey:cacheKey completion:aCompletion];

    } else {
        if (aCompletion != nil) {
            aCompletion(NO);
        }
    }
}

- (id <PNYRestRequest>)getInstallationWithSuccess:(void (^)(PNYInstallationDto *aInstallation))aSuccess
                                          failure:(PNYRestServiceFailureBlock)aFailure
                                         useCache:(BOOL)aUseCache
{
    PNYAssert(self.targetService != nil);

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getInstallationWithSuccess:aWrappedSuccess
                                                      failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.installationCache key:KEY_INSTALLATION
                                   success:aSuccess failure:aFailure
                                  useCache:aUseCache requestBlock:requestBlock];
}

- (id <PNYRestRequest>)getCurrentUserWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
                                        useCache:(BOOL)aUseCache
{
    PNYAssert(self.targetService != nil);

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getCurrentUserWithSuccess:aWrappedSuccess
                                                     failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.currentUserCache key:KEY_CURRENT_USER
                                   success:aSuccess failure:aFailure
                                  useCache:aUseCache requestBlock:requestBlock];
}

- (id <PNYRestRequest>)getArtistsWithSuccess:(void (^)(NSArray *aArtists))aSuccess
                                     failure:(PNYRestServiceFailureBlock)aFailure
                                    useCache:(BOOL)aUseCache
{
    PNYAssert(self.targetService != nil);

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getArtistsWithSuccess:aWrappedSuccess
                                                 failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.artistsCache key:KEY_ARTISTS
                                   success:aSuccess failure:aFailure
                                  useCache:aUseCache requestBlock:requestBlock];
}

- (id <PNYRestRequest>)getArtistAlbumsWithArtist:(NSString *)aArtistIdOrName
                                         success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
                                        useCache:(BOOL)aUseCache
{
    PNYAssert(self.targetService != nil);

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getArtistAlbumsWithArtist:aArtistIdOrName
                                                     success:aWrappedSuccess
                                                     failure:aWrappedFailure];
    };

    NSString *cacheKey = [NSString stringWithFormat:KEY_ARTIST_ALBUMS, aArtistIdOrName];

    return [self runCachedRequestWithCache:self.artistAlbumsCache key:cacheKey
                                   success:aSuccess failure:aFailure
                                  useCache:aUseCache requestBlock:requestBlock];
}

- (id <PNYRestRequest>)getImage:(NSString *)aAbsoluteUrl
                        success:(void (^)(UIImage *aImage))aSuccess
                        failure:(PNYRestServiceFailureBlock)aFailure
                       useCache:(BOOL)aUseCache
{
    PNYAssert(self.targetService != nil);

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getImage:aAbsoluteUrl success:aWrappedSuccess failure:aWrappedFailure];
    };

    NSString *cacheKey = [NSString stringWithFormat:KEY_IMAGES, aAbsoluteUrl];

    return [self runCachedRequestWithCache:self.imageCache key:cacheKey
                                   success:aSuccess failure:aFailure
                                  useCache:aUseCache requestBlock:requestBlock];
}

#pragma mark - <PNYRestService>

- (id <PNYRestRequest>)getInstallationWithSuccess:(void (^)(PNYInstallationDto *aInstallation))aSuccess
                                          failure:(PNYRestServiceFailureBlock)aFailure
{
    return [self getInstallationWithSuccess:aSuccess failure:aFailure useCache:YES];
}

- (id <PNYRestRequest>)authenticateWithCredentials:(PNYCredentialsDto *)aCredentials
                                           success:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                                           failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    return [self.targetService authenticateWithCredentials:aCredentials success:aSuccess failure:aFailure];
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
    return [self getCurrentUserWithSuccess:aSuccess failure:aFailure useCache:YES];
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
    return [self getArtistsWithSuccess:aSuccess failure:aFailure useCache:YES];
}

- (id <PNYRestRequest>)getArtistAlbumsWithArtist:(NSString *)aArtistIdOrName
                                         success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
{
    return [self getArtistAlbumsWithArtist:aArtistIdOrName success:aSuccess failure:aFailure useCache:YES];
}

- (id <PNYRestRequest>)getImage:(NSString *)aAbsoluteUrl
                        success:(void (^)(UIImage *aImage))aSuccess
                        failure:(PNYRestServiceFailureBlock)aFailure
{
    return [self getImage:aAbsoluteUrl success:aSuccess failure:aFailure useCache:YES];
}

#pragma mark - Private

- (id <PNYRestRequest>)runCachedRequestWithCache:(PNYCacheAsync *)aCache key:(NSString *)aKey
                                         success:(PNYRestServiceSuccessBlock)aSuccess failure:(PNYRestServiceFailureBlock)aFailure
                                        useCache:(BOOL)aUseCache requestBlock:(PNYRestServiceCachedRequestBlock)aRequestBlock
{
    if (aCache != nil) {

        PNYRestRequestProxy *request = [PNYRestRequestProxy new];

        void (^doRequestAndCacheResult)() = ^{
            request.targetRequest = aRequestBlock(^(id aData) {
                [aCache cacheValue:aData forKey:aKey completion:^{
                    if (aSuccess != nil) {
                        aSuccess(aData);
                    }
                }];
            }, aFailure);
        };

        if (aUseCache) {
            [aCache cachedValueForKey:aKey completion:^(id aCachedValue) {
                if (!request.cancelled) {
                    if (aCachedValue != nil) {

                        PNYLogDebug(@"Cache hit for key [%@] in cache %@.", aKey, aCache);

                        if (aSuccess != nil) {
                            aSuccess(aCachedValue);
                        }

                    } else {

                        PNYLogVerbose(@"Cache miss for key [%@] in cache %@.", aKey, aCache);

                        doRequestAndCacheResult();
                    }
                } else {
                    if (aFailure != nil) {
                        aFailure(@[[PNYErrorDto errorWithCode:PNYErrorDtoCodeClientRequestCancelled
                                                         text:@"Server request has been cancelled." arguments:nil]]);
                    }
                }
            }];
        } else {
            doRequestAndCacheResult();
        }

        return request;
    }

    return aRequestBlock(aSuccess, aFailure);
}

@end