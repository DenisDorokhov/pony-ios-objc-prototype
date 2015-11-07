//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "TyphoonAssembly.h"
#import "PNYCacheAsync.h"

@interface PNYCacheAssembly : TyphoonAssembly

- (PNYCacheAsync *)installationCacheAsync;
- (PNYCacheAsync *)currentUserCacheAsync;
- (PNYCacheAsync *)artistsCacheAsync;
- (PNYCacheAsync *)artistAlbumsCacheAsync;

- (id <PNYCache>)installationCache;
- (id <PNYCache>)currentUserCache;
- (id <PNYCache>)artistsCache;
- (id <PNYCache>)artistAlbumsCache;

@end