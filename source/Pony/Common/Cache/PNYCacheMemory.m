//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCacheMemory.h"

@implementation PNYCacheMemory
{
@private
    NSCache *memoryCache;
}

- (instancetype)initWithTargetCache:(id <PNYCache>)aTargetCache
{
    self = [self init];
    if (self != nil) {
        _targetCache = aTargetCache;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        memoryCache = [NSCache new];
    }
    return self;
}

#pragma mark - <PNYCache>

- (id)cachedValueForKey:(NSString *)aKey
{
    id value = [memoryCache objectForKey:aKey];
    if (value == nil) {
        value = [_targetCache cachedValueForKey:aKey];
    }
    if (value != nil) {
        [memoryCache setObject:value forKey:aKey];
    }
    return value;
}

- (void)cacheValue:(id)aValue forKey:(NSString *)aKey
{
    [_targetCache cacheValue:aValue forKey:aKey];
    [memoryCache setObject:aValue forKey:aKey];
}

- (void)removeCachedValueForKey:(NSString *)aKey
{
    [_targetCache removeCachedValueForKey:aKey];
    [memoryCache removeObjectForKey:aKey];
}

- (void)removeAllCachedValues
{
    [_targetCache removeAllCachedValues];
    [memoryCache removeAllObjects];
}

@end