//
// Created by Denis Dorokhov on 03/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestService.h"

@protocol PNYRestServiceCached <PNYRestService>

- (void)cachedValueExistsForInstallation:(void (^)(BOOL aCachedValueExists))aCompletion;
- (void)cachedValueExistsForCurrentUser:(void (^)(BOOL aCachedValueExists))aCompletion;
- (void)cachedValueExistsForArtists:(void (^)(BOOL aCachedValueExists))aCompletion;
- (void)cachedValueExistsForArtistAlbums:(NSString *)aArtistIdOrName completion:(void (^)(BOOL aCachedValueExists))aCompletion;
- (void)cachedValueExistsForImage:(NSString *)aAbsoluteUrl completion:(void (^)(BOOL aCachedValueExists))aCompletion;

- (id <PNYRestRequest>)getInstallationWithSuccess:(void (^)(PNYInstallationDto *aInstallation))aSuccess
                                          failure:(PNYRestServiceFailureBlock)aFailure
                                         useCache:(BOOL)aUseCache;

- (id <PNYRestRequest>)getCurrentUserWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
                                        useCache:(BOOL)aUseCache;

- (id <PNYRestRequest>)getArtistsWithSuccess:(void (^)(NSArray *aArtists))aSuccess
                                     failure:(PNYRestServiceFailureBlock)aFailure
                                    useCache:(BOOL)aUseCache;

- (id <PNYRestRequest>)getArtistAlbumsWithArtist:(NSString *)aArtistIdOrName
                                         success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
                                        useCache:(BOOL)aUseCache;

- (id <PNYRestRequest>)downloadImage:(NSString *)aAbsoluteUrl
                             success:(void (^)(UIImage *aImage))aSuccess
                             failure:(PNYRestServiceFailureBlock)aFailure
                            useCache:(BOOL)aUseCache;

@end