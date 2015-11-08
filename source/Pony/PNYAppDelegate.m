//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAppDelegate.h"

@implementation PNYAppDelegate

- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
    PNYAssert(self.config != nil);

    PNYLogInfo(@"Application started.");

    self.window.tintColor = [self.config colorValue:@"window.tintColor"];

    return YES;
}

@end