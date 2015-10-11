//
//  PNYAppDelegate.m
//  Pony
//
//  Created by Denis Dorokhov on 11/10/15.
//  Copyright © 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAppDelegate.h"
#import <CocoaLumberjack/DDASLLogger.h>
#import <CocoaLumberjack/DDTTYLogger.h>

@interface PNYAppDelegate ()

@end

@implementation PNYAppDelegate

- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    return YES;
}

@end