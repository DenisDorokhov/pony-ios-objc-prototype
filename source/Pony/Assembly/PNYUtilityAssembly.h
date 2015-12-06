//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <Typhoon/TyphoonAssembly.h>
#import "PNYUserSettings.h"
#import "PNYEventBus.h"
#import "PNYConfig.h"
#import "PNYPersistentDictionary.h"

@interface PNYUtilityAssembly : TyphoonAssembly

- (id <PNYConfig>)config;

- (id <PNYEventBus>)eventBus;

- (id <PNYUserSettings>)userSettings;

- (id <PNYPersistentDictionary>)persistentDictionary;
- (id <PNYPersistentDictionary>)keychainDictionary;

@end