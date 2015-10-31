//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestService.h"
#import "PNYCacheAsync.h"

@interface PNYRestServiceCached : NSObject <PNYRestService>

@property (nonatomic, readonly) id <PNYRestService> targetService;

@property (nonatomic, strong) PNYCacheAsync *cacheInstallation;
@property (nonatomic, strong) PNYCacheAsync *cacheCurrentUser;
@property (nonatomic, strong) PNYCacheAsync *cacheArtists;
@property (nonatomic, strong) PNYCacheAsync *cacheArtistAlbums;

- (instancetype)initWithTargetService:(id <PNYRestService>)aTargetService;

- (instancetype)init __unavailable;

@end