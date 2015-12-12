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

        self.capacity = 50;
    }
    return self;
}

#pragma mark - Public

- (NSUInteger)capacity
{
    return memoryCache.countLimit;
}

- (void)setCapacity:(NSUInteger)aCapacity
{
    memoryCache.countLimit = aCapacity;
}

#pragma mark - <PNYCache>

- (BOOL)cachedValueExistsForKey:(NSString *)aKey
{
    return [memoryCache objectForKey:aKey] != nil || [self.targetCache cachedValueExistsForKey:aKey];
}

- (id)cachedValueForKey:(NSString *)aKey
{
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
    [self.targetCache cacheValue:aValue forKey:aKey];
    [memoryCache setObject:aValue forKey:aKey];
}

- (void)removeCachedValueForKey:(NSString *)aKey
{
    [self.targetCache removeCachedValueForKey:aKey];
    [memoryCache removeObjectForKey:aKey];
}

- (void)removeAllCachedValues
{
    [self.targetCache removeAllCachedValues];
    [memoryCache removeAllObjects];
}

#pragma mark - Override

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"%p", (__bridge void *)self];
    [description appendFormat:@", targetCache=%@", self.targetCache];
    [description appendString:@">"];
    return description;
}

@end