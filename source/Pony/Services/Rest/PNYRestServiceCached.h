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

@end