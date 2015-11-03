//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYMemoryCache.h"

@implementation PNYMemoryCache
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

        self.memoryCacheCapacity = 50;
    }
    return self;
}

#pragma mark - Public

- (NSUInteger)memoryCacheCapacity
{
    return memoryCache.countLimit;
}

- (void)setMemoryCacheCapacity:(NSUInteger)aMemoryCacheCapacity
{
    memoryCache.countLimit = aMemoryCacheCapacity;
}

#pragma mark - <PNYCache>

- (BOOL)cachedValueExistsForKey:(NSString *)aKey
{
    PNYAssert(self.targetCache != nil);

    return [memoryCache objectForKey:aKey] != nil || [self.targetCache cachedValueExistsForKey:aKey];
}

- (id)cachedValueForKey:(NSString *)aKey
{
    PNYAssert(self.targetCache != nil);

    id value = [memoryCache objectForKey:aKey];
    if (value == nil) {
        value = [self.targetCache cachedValueForKey:aKey];
    }
    if (value != nil) {
        [memoryCache setObject:value forKey:aKey];
    }
    return value;
}

- (void)cacheValue:(id)aValue forKey:(NSString *)aKey
{
    PNYAssert(self.targetCache != nil);

    [self.targetCache cacheValue:aValue forKey:aKey];
    [memoryCache setObject:aValue forKey:aKey];
}

- (void)removeCachedValueForKey:(NSString *)aKey
{
    PNYAssert(self.targetCache != nil);

    [self.targetCache removeCachedValueForKey:aKey];
    [memoryCache removeObjectForKey:aKey];
}

- (void)removeAllCachedValues
{
    PNYAssert(self.targetCache != nil);

    [self.targetCache removeAllCachedValues];
    [memoryCache removeAllObjects];
}

@end