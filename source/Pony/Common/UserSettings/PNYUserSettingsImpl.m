//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYUserSettingsImpl.h"
#import "NSMutableOrderedSet+NSValueNonretained.h"
#import "NSOrderedSet+NSValueNonretained.h"

@implementation PNYUserSettingsImpl
{
@private
    NSMutableOrderedSet *delegates;
    NSUserDefaults *userDefaults;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {

        delegates = [NSMutableOrderedSet orderedSet];
        userDefaults = [NSUserDefaults standardUserDefaults];

        self.userDefaultsPrefix = [NSString stringWithFormat:@"%@.", NSStringFromClass([self class])];
    }
    return self;
}

- (void)addDelegate:(id <PNYUserSettingsDelegate>)aDelegate
{
    [delegates addNonretainedObject:aDelegate];
}

- (void)removeDelegate:(id <PNYUserSettingsDelegate>)aDelegate
{
    [delegates removeNonretainedObject:aDelegate];
}

- (id)valueForKey:(NSString *)aKey
{
    id value = [userDefaults objectForKey:[self buildKey:aKey]];
    if (value == nil) {
        value = self.defaultSettings[aKey];
    }
    return value;
}

- (void)setValue:(id)aValue forKey:(NSString *)aKey
{
    [userDefaults setObject:aValue forKey:[self buildKey:aKey]];

    DDLogInfo(@"Value [%@] has been set for key [%@].", aValue, aKey);

    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(userSettings:didSetValue:forKey:)]) {
            [aObject userSettings:self didSetValue:aValue forKey:aKey];
        }
    }];
}

- (void)removeValueForKey:(NSString *)aKey
{
    [userDefaults removeObjectForKey:aKey];

    DDLogInfo(@"Value has been removed for key [%@].", aKey);

    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(userSettings:didRemoveValueForKey:)]) {
            [aObject userSettings:self didRemoveValueForKey:aKey];
        }
    }];
}

- (void)save
{
    [userDefaults synchronize];

    DDLogInfo(@"User settings have been saved.");

    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(userSettingsDidSave:)]) {
            [aObject userSettingsDidSave:self];
        }
    }];
}

- (void)clear
{
    NSMutableArray *keysToRemove = [NSMutableArray array];
    [[userDefaults dictionaryRepresentation] enumerateKeysAndObjectsUsingBlock:^(NSString *aKey, id aValue, BOOL *aStop) {
        if ([aKey hasPrefix:self.userDefaultsPrefix]) {
            [keysToRemove addObject:aKey];
        }
    }];
    for (NSString *key in keysToRemove) {
        [userDefaults removeObjectForKey:key];
    }

    DDLogInfo(@"User settings have been cleared.");

    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(userSettingsDidClear:)]) {
            [aObject userSettingsDidClear:self];
        }
    }];
}

#pragma mark - Private

- (NSString *)buildKey:(NSString *)aKey
{
    return [NSString stringWithFormat:@"%@%@", self.userDefaultsPrefix, aKey];
}

@end