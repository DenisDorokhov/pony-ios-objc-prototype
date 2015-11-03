//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceCached.h"
#import "PNYRestService.h"
#import "PNYCacheAsync.h"

@interface PNYRestServiceCachedImpl : NSObject <PNYRestServiceCached>

@property (nonatomic, readonly) id <PNYRestService> targetService;

@property (nonatomic, strong) PNYCacheAsync *installationCache;
@property (nonatomic, strong) PNYCacheAsync *currentUserCache;
@property (nonatomic, strong) PNYCacheAsync *artistsCache;
@property (nonatomic, strong) PNYCacheAsync *artistAlbumsCache;

- (instancetype)initWithTargetService:(id <PNYRestService>)aTargetService;

+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;

@end