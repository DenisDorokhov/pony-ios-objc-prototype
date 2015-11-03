//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCacheAsync.h"

@implementation PNYCacheAsync

+ (instancetype)cacheWithCache:(id <PNYCache>)aCache
{
    return [[self alloc] initWithCache:aCache];
}

- (instancetype)initWithCache:(id <PNYCache>)aCache
{
    self = [super init];
    if (self != nil) {
        _cache = aCache;
    }
    return self;
}

#pragma mark - Public

- (void)cachedValueExistsForKey:(NSString *)aKey completion:(void (^)(BOOL aCachedValueExists))aCompletion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        BOOL valueExists = [self.cache cachedValueExistsForKey:aKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (aCompletion != nil) {
                aCompletion(valueExists);
            }
        });
    });
}

- (void)cachedValueForKey:(NSString *)aKey completion:(void (^)(id aCachedValue))aCompletion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        id value = [self.cache cachedValueForKey:aKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (aCompletion != nil) {
                aCompletion(value);
            }
        });
    });
}

- (void)cacheValue:(id)aValue forKey:(NSString *)aKey completion:(void (^)())aCompletion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self.cache cacheValue:aValue forKey:aKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (aCompletion != nil) {
                aCompletion();
            }
        });
    });
}

- (void)removeCachedValueForKey:(NSString *)aKey completion:(void (^)())aCompletion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self.cache removeCachedValueForKey:aKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (aCompletion != nil) {
                aCompletion();
            }
        });
    });
}

- (void)removeAllCachedValuesWithCompletion:(void (^)())aCompletion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self.cache removeAllCachedValues];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (aCompletion != nil) {
                aCompletion();
            }
        });
    });
}

@end