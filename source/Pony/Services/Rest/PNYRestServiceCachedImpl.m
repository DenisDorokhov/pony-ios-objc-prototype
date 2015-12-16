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

- (id <PNYRestRequest>)getInstallationWithSuccess:(void (^)(PNYInstallationDto *aInstallation))aSuccess
                                          failure:(PNYRestServiceFailureBlock)aFailure
                                     cacheHandler:(BOOL (^)(PNYInstallationDto *aCachedInstallation))aCacheHandler;
{
    PNYAssert(self.targetService != nil);

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getInstallationWithSuccess:aWrappedSuccess
                                                      failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.installationCache key:KEY_INSTALLATION
                                   success:aSuccess failure:aFailure
                              cacheHandler:aCacheHandler requestBlock:requestBlock];
}

- (id <PNYRestRequest>)getCurrentUserWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
                                    cacheHandler:(BOOL (^)(PNYUserDto *aCachedInstallation))aCacheHandler
{
    PNYAssert(self.targetService != nil);

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getCurrentUserWithSuccess:aWrappedSuccess
                                                     failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.currentUserCache key:KEY_CURRENT_USER
                                   success:aSuccess failure:aFailure
                              cacheHandler:aCacheHandler requestBlock:requestBlock];
}

- (id <PNYRestRequest>)getArtistsWithSuccess:(void (^)(NSArray *aArtists))aSuccess
                                     failure:(PNYRestServiceFailureBlock)aFailure
                                cacheHandler:(BOOL (^)(NSArray *aCachedArtists))aCacheHandler;
{
    PNYAssert(self.targetService != nil);

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getArtistsWithSuccess:aWrappedSuccess
                                                 failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.artistsCache key:KEY_ARTISTS
                                   success:aSuccess failure:aFailure
                              cacheHandler:aCacheHandler requestBlock:requestBlock];
}

- (id <PNYRestRequest>)getArtistAlbumsWithArtist:(NSString *)aArtistIdOrName
                                         success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
                                    cacheHandler:(BOOL (^)(PNYArtistAlbumsDto *aCachedArtistAlbums))aCacheHandler
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
                              cacheHandler:aCacheHandler requestBlock:requestBlock];
}

- (id <PNYRestRequest>)downloadImage:(NSString *)aAbsoluteUrl
                             success:(void (^)(UIImage *aImage))aSuccess
                             failure:(PNYRestServiceFailureBlock)aFailure
                        cacheHandler:(BOOL (^)(UIImage *aCachedImage))aCacheHandler
{
    PNYAssert(self.targetService != nil);

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService downloadImage:aAbsoluteUrl success:aWrappedSuccess failure:aWrappedFailure];
    };

    NSString *cacheKey = [NSString stringWithFormat:KEY_IMAGES, aAbsoluteUrl];

    return [self runCachedRequestWithCache:self.imageCache key:cacheKey
                                   success:aSuccess failure:aFailure
                              cacheHandler:aCacheHandler requestBlock:requestBlock];
}

#pragma mark - <PNYRestService>

- (id <PNYRestRequest>)getInstallationWithSuccess:(void (^)(PNYInstallationDto *aInstallation))aSuccess
                                          failure:(PNYRestServiceFailureBlock)aFailure
{
    return [self getInstallationWithSuccess:aSuccess failure:aFailure cacheHandler:nil];
}

- (id <PNYRestRequest>)authenticateWithCredentials:(PNYCredentialsDto *)aCredentials
                                           success:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                                           failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    return [self.targetService authenticateWithCredentials:aCredentials success:^(PNYAuthenticationDto *aAuthentication) {
        if (self.currentUserCache != nil) {
            [self.currentUserCache cacheValue:aAuthentication.user forKey:KEY_CURRENT_USER completion:^{
                if (aSuccess != nil) {
                    aSuccess(aAuthentication);
                }
            }];
        } else {
            if (aSuccess != nil) {
                aSuccess(aAuthentication);
            }
        }
    }                                              failure:aFailure];
}

- (id <PNYRestRequest>)logoutWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                 failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    [self.currentUserCache removeCachedValueForKey:KEY_CURRENT_USER completion:nil];

    return [self.targetService logoutWithSuccess:aSuccess failure:aFailure];
}

- (id <PNYRestRequest>)getCurrentUserWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
{
    return [self getCurrentUserWithSuccess:aSuccess failure:aFailure cacheHandler:nil];
}

- (id <PNYRestRequest>)refreshTokenWithSuccess:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                                       failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    return [self.targetService refreshTokenWithSuccess:^(PNYAuthenticationDto *aAuthentication) {
        if (self.currentUserCache != nil) {
            [self.currentUserCache cacheValue:aAuthentication.user forKey:KEY_CURRENT_USER completion:^{
                if (aSuccess != nil) {
                    aSuccess(aAuthentication);
                }
            }];
        } else {
            if (aSuccess != nil) {
                aSuccess(aAuthentication);
            }
        }
    }                                          failure:aFailure];
}

- (id <PNYRestRequest>)getArtistsWithSuccess:(void (^)(NSArray *aArtists))aSuccess
                                     failure:(PNYRestServiceFailureBlock)aFailure
{
    return [self getArtistsWithSuccess:aSuccess failure:aFailure cacheHandler:nil];
}

- (id <PNYRestRequest>)getArtistAlbumsWithArtist:(NSString *)aArtistIdOrName
                                         success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
{
    return [self getArtistAlbumsWithArtist:aArtistIdOrName success:aSuccess failure:aFailure cacheHandler:nil];
}

- (id <PNYRestRequest>)getSongsWithIds:(NSArray *)aSongIds
                               success:(void (^)(NSArray *aSongs))aSuccess
                               failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    return [self.targetService getSongsWithIds:aSongIds success:aSuccess failure:aFailure];
}

- (id <PNYRestRequest>)downloadImage:(NSString *)aAbsoluteUrl
                             success:(void (^)(UIImage *aImage))aSuccess
                             failure:(PNYRestServiceFailureBlock)aFailure
{
    return [self downloadImage:aAbsoluteUrl success:aSuccess failure:aFailure cacheHandler:nil];
}

- (id <PNYRestRequest>)downloadSongWithId:(NSNumber *)aSongId toFile:(NSString *)aFilePath
                                 progress:(void (^)(float aValue))aProgress
                                  success:(void (^)())aSuccess
                                  failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    return [self.targetService downloadSongWithId:aSongId toFile:aFilePath
                                         progress:aProgress success:aSuccess failure:aFailure];
}

#pragma mark - Private

- (id <PNYRestRequest>)runCachedRequestWithCache:(PNYCacheAsync *)aCache key:(NSString *)aKey
                                         success:(PNYRestServiceSuccessBlock)aSuccess failure:(PNYRestServiceFailureBlock)aFailure
                                    cacheHandler:(BOOL (^)(id aCachedValue))aCacheHandler requestBlock:(PNYRestServiceCachedRequestBlock)aRequestBlock
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

        if (aCacheHandler != nil) {
            [aCache cachedValueForKey:aKey completion:^(id aCachedValue) {
                if (!request.cancelled) {

                    if (aCachedValue != nil) {
                        PNYLogVerbose(@"Cache hit for key [%@] in cache %@.", aKey, aCache);
                    } else {
                        PNYLogVerbose(@"Cache miss for key [%@] in cache %@.", aKey, aCache);
                    }

                    if (aCacheHandler(aCachedValue)) {

                        PNYLogVerbose(@"Proceeding to the request after cache handler.");

                        doRequestAndCacheResult();
                    }

                } else {

                    PNYLogVerbose(@"Request cancelled.");

                    if (aFailure != nil) {
                        aFailure(@[[PNYErrorDtoFactory createErrorClientRequestCancelled]]);
                    }
                }
            }];
        } else {

            PNYLogVerbose(@"Cache handler not defined, proceeding to the request.");

            doRequestAndCacheResult();
        }

        return request;
    }

    return aRequestBlock(aSuccess, aFailure);
}

@end