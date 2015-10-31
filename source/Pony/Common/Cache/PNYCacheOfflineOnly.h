//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCache.h"

@interface PNYCacheOfflineOnly : NSObject <PNYCache>

@property (nonatomic, readonly) id <PNYCache> targetCache;

- (instancetype)initWithTargetCache:(id <PNYCache>)aTargetCache;

- (instancetype)init __unavailable;

@end