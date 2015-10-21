//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYUserSettings.h"

@interface PNYUserSettingsImpl : NSObject <PNYUserSettings>

@property (nonatomic, copy) NSString *userDefaultsPrefix;

@property (nonatomic, copy) NSDictionary *defaultSettings;

@end