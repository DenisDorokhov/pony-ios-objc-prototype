//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCache.h"

@interface PNYCacheAsync : NSObject

@property (nonatomic, readonly) id <PNYCache> cache;

- (instancetype)initWithCache:(id <PNYCache>)aCache;

- (instancetype)init __unavailable;

- (void)cachedValueForKey:(NSString *)aKey completion:(void(^)(id))aCompletion;
- (void)cacheValue:(id)aValue forKey:(NSString *)aKey completion:(void(^)())aCompletion;

- (void)removeCachedValueForKey:(NSString *)aKey completion:(void(^)())aCompletion;
- (void)removeAllCachedValuesWithCompletion:(void(^)())aCompletion;

@end