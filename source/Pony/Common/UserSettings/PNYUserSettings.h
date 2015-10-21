//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@protocol PNYUserSettings;

@protocol PNYUserSettingsDelegate <NSObject>

@optional

- (void)userSettings:(id <PNYUserSettings>)aUserSettings didSetSetting:(id)aSetting forKey:(NSString *)aKey;
- (void)userSettings:(id <PNYUserSettings>)aUserSettings didRemoveSettingForKey:(NSString *)aKey;

- (void)userSettingsDidSave:(id <PNYUserSettings>)aUserSettings;
- (void)userSettingsDidClear:(id <PNYUserSettings>)aUserSettings;

@end

@protocol PNYUserSettings <NSObject>

- (void)addDelegate:(id <PNYUserSettingsDelegate>)aDelegate;
- (void)removeDelegate:(id <PNYUserSettingsDelegate>)aDelegate;

- (id)settingForKey:(NSString *)aKey;
- (void)setSetting:(id)aSetting forKey:(NSString *)aKey;
- (void)removeSettingForKey:(NSString *)aKey;

- (void)save;
- (void)clear;

@end