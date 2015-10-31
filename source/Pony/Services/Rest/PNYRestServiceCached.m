//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceCached.h"
#import "PNYRestRequestProxy.h"
#import "PNYMacros.h"

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

    if (self.cacheInstallation != nil) {

        NSString *cacheKey = @"installation";

        PNYRestRequestProxy *request = [PNYRestRequestProxy new];

        [self.cacheInstallation cachedValueForKey:cacheKey completion:^(PNYInstallationDto *aInstallation) {
            if (!request.cancelled) {
                if (aInstallation != nil) {
                    if (aSuccess != nil) {
                        aSuccess(aInstallation);
                    }
                } else {
                    request.targetRequest = [self.targetService getInstallationWithSuccess:[self wrapBlock:aSuccess
                                                                                                forCaching:self.cacheInstallation
                                                                                                   withKey:cacheKey]
                                                                               failure:aFailure];
                }
            }
        }];

        return request;
    }

    return [self.targetService getInstallationWithSuccess:aSuccess failure:aFailure];
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

    if (self.cacheCurrentUser != nil) {

        NSString *cacheKey = @"currentUser";

        PNYRestRequestProxy *request = [PNYRestRequestProxy new];

        [self.cacheCurrentUser cachedValueForKey:cacheKey completion:^(PNYUserDto *aUser) {
            if (!request.cancelled) {
                if (aUser != nil) {
                    if (aSuccess != nil) {
                        aSuccess(aUser);
                    }
                } else {
                    request.targetRequest = [self.targetService getCurrentUserWithSuccess:[self wrapBlock:aSuccess
                                                                                               forCaching:self.cacheCurrentUser
                                                                                                  withKey:cacheKey]
                                                                              failure:aFailure];
                }
            }
        }];

        return request;
    }

    return [self.targetService getCurrentUserWithSuccess:aSuccess failure:aFailure];
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

    if (self.cacheArtists != nil) {

        NSString *cacheKey = @"artists";

        PNYRestRequestProxy *request = [PNYRestRequestProxy new];

        [self.cacheArtists cachedValueForKey:cacheKey completion:^(NSArray *aArtists) {
            if (!request.cancelled) {
                if (aArtists != nil) {
                    if (aSuccess != nil) {
                        aSuccess(aArtists);
                    }
                } else {
                    request.targetRequest = [self.targetService getArtistsWithSuccess:[self wrapBlock:aSuccess
                                                                                           forCaching:self.cacheArtists
                                                                                              withKey:cacheKey]
                                                                          failure:aFailure];
                }
            }
        }];

        return request;
    }

    return [self.targetService getArtistsWithSuccess:aSuccess failure:aFailure];
}

- (id <PNYRestRequest>)getArtistAlbums:(NSString *)aArtistIdOrName
                               success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                               failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.targetService != nil);

    if (self.cacheArtistAlbums != nil) {

        NSString *cacheKey = [NSString stringWithFormat:@"artistAlbums.[%@]", aArtistIdOrName];

        PNYRestRequestProxy *request = [PNYRestRequestProxy new];

        [self.cacheArtistAlbums cachedValueForKey:cacheKey completion:^(PNYArtistAlbumsDto *aArtistAlbums) {
            if (!request.cancelled) {
                if (aArtistAlbums != nil) {
                    if (aSuccess != nil) {
                        aSuccess(aArtistAlbums);
                    }
                } else {
                    request.targetRequest = [self.targetService getArtistAlbums:aArtistIdOrName
                                                                    success:[self wrapBlock:aSuccess
                                                                                 forCaching:self.cacheArtistAlbums
                                                                                    withKey:cacheKey]
                                                                    failure:aFailure];
                }
            }
        }];

        return request;
    }

    return [self.targetService getArtistAlbums:aArtistIdOrName success:aSuccess failure:aFailure];
}

#pragma mark - Private

- (void(^)(id aValue))wrapBlock:(void(^)(id))aBlock forCaching:(PNYCacheAsync *)aCache withKey:(NSString *)aKey
{
    return ^(id aValue) {
        if (aValue != nil) {
            [aCache cacheValue:aValue forKey:aKey completion:nil];
        }
        if (aBlock != nil) {
            aBlock(aValue);
        }
    };
}

@end