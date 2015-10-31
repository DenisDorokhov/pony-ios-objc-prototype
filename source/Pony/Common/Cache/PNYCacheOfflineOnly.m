//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "PNYCacheOfflineOnly.h"
#import "PNYMacros.h"

@implementation PNYCacheOfflineOnly

- (instancetype)initWithTargetCache:(id <PNYCache>)aTargetCache
{
    self = [super init];
    if (self != nil) {
        _targetCache = aTargetCache;
    }
    return self;
}

#pragma mark - <PNYCache>

- (id)cachedValueForKey:(NSString *)aKey
{
    PNYAssert(_targetCache != nil);

    return [self isOnline] ? nil : [_targetCache cachedValueForKey:aKey];
}

- (void)cacheValue:(id)aValue forKey:(NSString *)aKey
{
    PNYAssert(_targetCache != nil);

    [_targetCache cacheValue:aValue forKey:aKey];
}

- (void)removeCachedValueForKey:(NSString *)aKey
{
    PNYAssert(_targetCache != nil);

    [_targetCache removeCachedValueForKey:aKey];
}

- (void)removeAllCachedValues
{
    PNYAssert(_targetCache != nil);

    [_targetCache removeAllCachedValues];
}

#pragma mark - Private

- (BOOL)isOnline
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

@end