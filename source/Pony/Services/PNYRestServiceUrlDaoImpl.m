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

    NSString *protocolValue = [self.userSettings settingForKey:PNYUserSettingsKeyRestProtocol];
    NSString *urlValue = [self.userSettings settingForKey:PNYUserSettingsKeyRestUrl];

    if (protocolValue != nil && urlValue != nil) {

        NSMutableString *url = [NSMutableString string];

        [url appendString:protocolValue];
        [url appendString:@"://"];
        [url appendString:urlValue];

        return [NSURL URLWithString:url];
    }

    return nil;
}

- (void)storeUrl:(NSURL *)aServiceUrl
{
    PNYAssert(aServiceUrl != nil);

    PNYAssert(self.userSettings != nil);

    [self.userSettings setSetting:aServiceUrl.scheme forKey:PNYUserSettingsKeyRestUrl];

    NSString *url = aServiceUrl.host;

    url = [url stringByAppendingFormat:@":%@", aServiceUrl.port];
    url = [url stringByAppendingPathComponent:aServiceUrl.path];

    [self.userSettings setSetting:url forKey:PNYUserSettingsKeyRestUrl];
}

- (void)removeUrl
{
    PNYAssert(self.userSettings != nil);

    [self.userSettings removeSettingForKey:PNYUserSettingsKeyRestProtocol];
    [self.userSettings removeSettingForKey:PNYUserSettingsKeyRestUrl];

    [self.userSettings save];
}

@end