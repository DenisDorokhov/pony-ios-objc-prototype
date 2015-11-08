//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceUrlDaoImpl.h"
#import "PNYUserSettingsKeys.h"

@implementation PNYRestServiceUrlDaoImpl

#pragma mark - <PNYRestServiceUrlDao>

- (NSURL *)fetchUrl
{
    PNYAssert(self.userSettings != nil);

    NSString *urlValue = [self.userSettings settingForKey:PNYUserSettingsKeyRestServiceUrl];

    return urlValue != nil ? [NSURL URLWithString:urlValue] : nil;
}

- (void)storeUrl:(NSURL *)aServiceUrl
{
    PNYAssert(aServiceUrl != nil);

    PNYAssert(self.userSettings != nil);

    [self.userSettings setSetting:[aServiceUrl absoluteString] forKey:PNYUserSettingsKeyRestServiceUrl];
}

- (void)removeUrl
{
    PNYAssert(self.userSettings != nil);

    [self.userSettings removeSettingForKey:PNYUserSettingsKeyRestServiceUrl];

    [self.userSettings save];
}

@end