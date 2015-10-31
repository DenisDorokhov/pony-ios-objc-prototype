//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@protocol PNYCache <NSObject>

- (id)cachedValueForKey:(NSString *)aKey;
- (void)cacheValue:(id)aValue forKey:(NSString *)aKey;

- (void)removeCachedValueForKey:(NSString *)aKey;
- (void)removeAllCachedValues;

@end