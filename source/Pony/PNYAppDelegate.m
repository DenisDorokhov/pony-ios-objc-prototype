//
//  PNYAppDelegate.m
//  Pony
//
//  Created by Denis Dorokhov on 11/10/15.
//  Copyright © 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAppDelegate.h"
#import "PNYLogFormatter.h"
#import "PNYMacros.h"

@interface PNYAppDelegate ()

@end

@implementation PNYAppDelegate

#ifdef DEBUG
static const DDLogLevel LOG_LEVEL = DDLogLevelDebug;
#else
static const DDLogLevel LOG_LEVEL = DDLogLevelOff;
#endif

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
    [DDLog addLogger:logger withLevel:LOG_LEVEL];
}

@end