//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceCachedImpl.h"
#import "PNYRestRequestProxy.h"

typedef id <PNYRestRequest>(^PNYRestServiceCachedRequestBlock)(PNYRestServiceSuccessBlock aSuccess, PNYRestServiceFailureBlock aFailure);

@implementation PNYRestServiceCachedImpl

static NSString *const KEY_INSTALLATION = @"installation";
static NSString *const KEY_CURRENT_USER = @"currentUser";
static NSString *const KEY_ARTISTS = @"artists";
static NSString *const KEY_ARTIST_ALBUMS = @"artistAlbums.%@";

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
    }
}

- (void)cachedValueExistsForCurrentUser:(void (^)(BOOL aCachedValueExists))aCompletion
{
    if (self.currentUserCache != nil) {
        [self.currentUserCache cachedValueExistsForKey:KEY_CURRENT_USER completion:aCompletion];
    }
}

- (void)cachedValueExistsForArtists:(void (^)(BOOL aCachedValueExists))aCompletion
{
    if (self.artistsCache != nil) {
        [self.artistsCache cachedValueExistsForKey:KEY_ARTISTS completion:aCompletion];
    }
}

- (void)cachedValueExistsForArtistAlbums:(NSString *)aArtistIdOrName completion:(void (^)(BOOL aCachedValueExists))aCompletion
{
    if (self.artistAlbumsCache != nil) {

        NSString *cacheKey = [NSString stringWithFormat:KEY_ARTIST_ALBUMS, aArtistIdOrName];

        [self.artistAlbumsCache cachedValueExistsForKey:cacheKey completion:aCompletion];
    }
}

- (id <PNYRestRequest>)getInstallationWithSuccess:(void (^)(PNYInstallationDto *aInstallation))aSuccess
                                          failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getInstallationWithSuccess:aWrappedSuccess
                                                      failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.installationCache key:KEY_INSTALLATION
                                   success:aSuccess failure:aFailure block:requestBlock];
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
    PNYAssert(self.targetService != nil);

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getCurrentUserWithSuccess:aWrappedSuccess
                                                     failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.currentUserCache key:KEY_CURRENT_USER
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

    PNYRestServiceCachedRequestBlock requestBlock = ^id <PNYRestRequest>(
            PNYRestServiceSuccessBlock aWrappedSuccess, PNYRestServiceFailureBlock aWrappedFailure) {
        return [self.targetService getArtistsWithSuccess:aWrappedSuccess
                                                 failure:aWrappedFailure];
    };

    return [self runCachedRequestWithCache:self.artistsCache key:KEY_ARTISTS
                                   success:aSuccess failure:aFailure block:requestBlock];
}

- (id <PNYRestRequest>)getArtistAlbumsWithArtist:(NSString *)aArtistIdOrName
                                         success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
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
                                   success:aSuccess failure:aFailure block:requestBlock];
}

#pragma mark - Private

- (id <PNYRestRequest>)runCachedRequestWithCache:(PNYCacheAsync *)aCache key:(NSString *)aKey
                                         success:(PNYRestServiceSuccessBlock)aSuccess failure:(PNYRestServiceFailureBlock)aFailure
                                           block:(PNYRestServiceCachedRequestBlock)aBlock
{
    if (aCache != nil) {

        PNYRestRequestProxy *request = [PNYRestRequestProxy new];

        [aCache cachedValueForKey:aKey completion:^(id aCachedValue) {
            if (!request.cancelled) {
                if (aCachedValue != nil) {

                    if (aCache.cache.name != nil) {
                        PNYLogVerbose(@"Cache hit for key [%@] in cache [%@].", aKey, aCache.cache.name);
                    } else {
                        PNYLogVerbose(@"Cache hit for key [%@].", aKey);
                    }

                    if (aSuccess != nil) {
                        aSuccess(aCachedValue);
                    }

                } else {

                    if (aCache.cache.name != nil) {
                        PNYLogVerbose(@"Cache miss for key [%@] in cache [%@].", aKey, aCache.cache.name);
                    } else {
                        PNYLogVerbose(@"Cache miss for key [%@].", aKey);
                    }

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