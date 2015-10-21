//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@protocol PNYUserSettings;

@protocol PNYUserSettingsDelegate <NSObject>

@optional

- (void)userSettings:(id <PNYUserSettings>)aUserSettings didSetValue:(id)aValue forKey:(NSString *)aKey;
- (void)userSettings:(id <PNYUserSettings>)aUserSettings didRemoveValueForKey:(NSString *)aKey;

- (void)userSettingsDidSave:(id <PNYUserSettings>)aUserSettings;
- (void)userSettingsDidClear:(id <PNYUserSettings>)aUserSettings;

@end

@protocol PNYUserSettings <NSObject>

- (void)addDelegate:(id <PNYUserSettingsDelegate>)aDelegate;
- (void)removeDelegate:(id <PNYUserSettingsDelegate>)aDelegate;

- (id)valueForKey:(NSString *)aKey;
- (void)setValue:(id)aValue forKey:(NSString *)aKey;
- (void)removeValueForKey:(NSString *)aKey;

- (void)save;
- (void)clear;

@end