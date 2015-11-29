//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <Typhoon/TyphoonAssembly.h>
#import "PNYCacheAsync.h"

@interface PNYCacheAssembly : TyphoonAssembly

- (PNYCacheAsync *)installationCacheAsync;
- (PNYCacheAsync *)currentUserCacheAsync;
- (PNYCacheAsync *)artistsCacheAsync;
- (PNYCacheAsync *)artistAlbumsCacheAsync;
- (PNYCacheAsync *)imageCacheAsync;

@end