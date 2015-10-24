//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAppDelegate.h"
#import "PNYLogFormatter.h"
#import "PNYMacros.h"

@interface PNYAppDelegate ()

@end

@implementation PNYAppDelegate

- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
    [self setupLogging];

    PNYLogInfo(@"Application started.");

    return YES;
}

#pragma mark - Private

- (void)setupLogging
{
    DDTTYLogger *logger = [DDTTYLogger sharedInstance];
    logger.logFormatter = [[PNYLogFormatter alloc] init];
    [DDLog addLogger:logger withLevel:DDLogLevelDebug];
}

@end