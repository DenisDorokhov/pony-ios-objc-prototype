//
//  PNYAppDelegate.m
//  Pony
//
//  Created by Denis Dorokhov on 11/10/15.
//  Copyright © 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAppDelegate.h"
#import "PNYLogFormatter.h"

@interface PNYAppDelegate ()

@end

@implementation PNYAppDelegate

- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
    DDTTYLogger *logger = [DDTTYLogger sharedInstance];
    logger.logFormatter = [[PNYLogFormatter alloc] init];
    [DDLog addLogger:logger];

    DDLogInfo(@"Application started.");

    return YES;
}

@end