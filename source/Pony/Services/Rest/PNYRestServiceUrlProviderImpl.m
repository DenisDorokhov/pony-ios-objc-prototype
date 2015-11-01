//
// Created by Denis Dorokhov on 25/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceUrlProviderImpl.h"
#import "PNYUserSettingsKeys.h"

@implementation PNYRestServiceUrlProviderImpl

#pragma mark - <PNYRestServiceUrlProvider>

- (NSURL *)serverUrl
{
    PNYAssert(self.userSettings != nil);

    NSMutableString *url = [NSMutableString string];

    [url appendString:[self.userSettings settingForKey:PNYUserSettingsKeyRestProtocol]];
    [url appendString:@"://"];
    [url appendString:[self.userSettings settingForKey:PNYUserSettingsKeyRestUrl]];

    return [NSURL URLWithString:url];
}

@end