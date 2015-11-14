//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYUserSettingsImpl.h"
#import "NSMutableOrderedSet+PNYNSValue.h"
#import "NSOrderedSet+PNYNSValue.h"

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

- (id)settingForKey:(NSString *)aKey
{
    id setting = [userDefaults objectForKey:[self buildKey:aKey]];
    if (setting == nil) {
        setting = self.defaultSettings[aKey];
    }
    return setting;
}

- (void)setSetting:(id)aSetting forKey:(NSString *)aKey
{
    [userDefaults setObject:aSetting forKey:[self buildKey:aKey]];

    PNYLogVerbose(@"Setting for key [%@] has been set: [%@].", aKey, aSetting);

    // TODO: remove casting when AppCode finally supports this
    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYUserSettingsDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(userSettings:didSetSetting:forKey:)]) {
            [aObject userSettings:self didSetSetting:aSetting forKey:aKey];
        }
    }];
}

- (void)removeSettingForKey:(NSString *)aKey
{
    [userDefaults removeObjectForKey:[self buildKey:aKey]];

    PNYLogVerbose(@"Setting for key [%@] has been removed.", aKey);

    // TODO: remove casting when AppCode finally supports this
    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYUserSettingsDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(userSettings:didRemoveSettingForKey:)]) {
            [aObject userSettings:self didRemoveSettingForKey:aKey];
        }
    }];
}

- (void)save
{
    [userDefaults synchronize];

    PNYLogVerbose(@"User settings have been saved.");

    // TODO: remove casting when AppCode finally supports this
    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYUserSettingsDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
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

    PNYLogVerbose(@"User settings have been cleared.");

    // TODO: remove casting when AppCode finally supports this
    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYUserSettingsDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
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