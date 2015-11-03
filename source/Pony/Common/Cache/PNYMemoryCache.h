//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCache.h"

@interface PNYMemoryCache : NSObject <PNYCache>

@property (nonatomic, readonly) id <PNYCache> targetCache;

@property (nonatomic) NSUInteger memoryCacheCapacity;

- (instancetype)initWithTargetCache:(id <PNYCache>)aTargetCache;

@end