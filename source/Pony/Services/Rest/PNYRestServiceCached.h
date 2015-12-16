//
// Created by Denis Dorokhov on 03/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestService.h"

typedef BOOL (^PNYRestServiceCacheHandlerBlock)(id aCachedValue);

@protocol PNYRestServiceCached <PNYRestService>

- (id <PNYRestRequest>)getInstallationWithSuccess:(void (^)(PNYInstallationDto *aInstallation))aSuccess
                                          failure:(PNYRestServiceFailureBlock)aFailure
                                     cacheHandler:(BOOL (^)(PNYInstallationDto *aCachedInstallation))aCacheHandler;

- (id <PNYRestRequest>)getCurrentUserWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
                                    cacheHandler:(BOOL (^)(PNYUserDto *aCachedInstallation))aCacheHandler;

- (id <PNYRestRequest>)getArtistsWithSuccess:(void (^)(NSArray *aArtists))aSuccess
                                     failure:(PNYRestServiceFailureBlock)aFailure
                                cacheHandler:(BOOL (^)(NSArray *aCachedArtists))aCacheHandler;

- (id <PNYRestRequest>)getArtistAlbumsWithArtist:(NSString *)aArtistIdOrName
                                         success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
                                    cacheHandler:(BOOL (^)(PNYArtistAlbumsDto *aCachedArtistAlbums))aCacheHandler;

- (id <PNYRestRequest>)downloadImage:(NSString *)aAbsoluteUrl
                             success:(void (^)(UIImage *aImage))aSuccess
                             failure:(PNYRestServiceFailureBlock)aFailure
                        cacheHandler:(BOOL (^)(UIImage *aCachedImage))aCacheHandler;

@end