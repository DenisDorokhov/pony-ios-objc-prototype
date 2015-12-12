//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCacheAsync.h"

@implementation PNYCacheAsync

+ (instancetype)cacheWithAsynchronousCache:(id <PNYCache>)aAsynchronousCache
{
    return [[self alloc] initWithAsynchronousCache:aAsynchronousCache];
}

- (instancetype)initWithAsynchronousCache:(id <PNYCache>)aAsynchronousCache
{
    self = [super init];
    if (self != nil) {
        _asynchronousCache = aAsynchronousCache;
    }
    return self;
}

#pragma mark - Public

- (void)cachedValueExistsForKey:(NSString *)aKey completion:(void (^)(BOOL aCachedValueExists))aCompletion
{
    if ([self.synchronousCache cachedValueExistsForKey:aKey]) {
        if (aCompletion != nil) {
            aCompletion(YES);
        }
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

            BOOL valueExists = [self.asynchronousCache cachedValueExistsForKey:aKey];

            dispatch_async(dispatch_get_main_queue(), ^{
                if (aCompletion != nil) {
                    aCompletion(valueExists);
                }
            });
        });
    }
}

- (void)cachedValueForKey:(NSString *)aKey completion:(void (^)(id aCachedValue))aCompletion
{
    __block id value = [self.synchronousCache cachedValueForKey:aKey];

    if (value != nil) {
        if (aCompletion != nil) {
            aCompletion(value);
        }
    } else {

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            value = [self.asynchronousCache cachedValueForKey:aKey];

            if (value != nil) {
                [self.synchronousCache cacheValue:value forKey:aKey];
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                if (aCompletion != nil) {
                    aCompletion(value);
                }
            });
        });
    }
}

- (void)cacheValue:(id)aValue forKey:(NSString *)aKey completion:(void (^)())aCompletion
{
    [self.synchronousCache cacheValue:aValue forKey:aKey];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self.asynchronousCache cacheValue:aValue forKey:aKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (aCompletion != nil) {
                aCompletion();
            }
        });
    });
}

- (void)removeCachedValueForKey:(NSString *)aKey completion:(void (^)())aCompletion
{
    [self.synchronousCache removeCachedValueForKey:aKey];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self.asynchronousCache removeCachedValueForKey:aKey];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (aCompletion != nil) {
                aCompletion();
            }
        });
    });
}

- (void)removeAllCachedValuesWithCompletion:(void (^)())aCompletion
{
    [self.synchronousCache removeAllCachedValues];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        [self.asynchronousCache removeAllCachedValues];

        dispatch_async(dispatch_get_main_queue(), ^{
            if (aCompletion != nil) {
                aCompletion();
            }
        });
    });
}

#pragma mark - Override

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"asynchronousCache=%@", self.asynchronousCache];
    [description appendFormat:@", synchronousCache=%@", self.synchronousCache];
    [description appendString:@">"];
    return description;
}

@end