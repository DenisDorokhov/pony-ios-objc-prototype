//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAppDelegate.h"
#import "PNYUtilityAssembly.h"
#import "PNYCacheAssembly.h"
#import "PNYServiceAssembly.h"
#import "PNYAppAssembly.h"
#import <Typhoon/TyphoonBlockComponentFactory.h>
#import "PNYMacros.h"

@implementation PNYAppDelegate

#pragma mark - <UIApplicationDelegate>

- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
    [self setupTyphoon];

    PNYAssert(self.config != nil);

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Bootstrap" bundle:[NSBundle mainBundle]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [self.config colorValue:@"window.backgroundColor"];
    self.window.rootViewController = [storyboard instantiateInitialViewController];

    PNYLogInfo(@"Application started.");

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    PNYLogInfo(@"Application paused.");
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    PNYLogInfo(@"Application became active.");
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    PNYLogInfo(@"Application received memory warning.");
}

#pragma mark - Private

- (void)setupTyphoon
{
    id <TyphoonComponentFactory> componentFactory = [TyphoonBlockComponentFactory factoryWithAssemblies:@[
            [PNYUtilityAssembly assembly],
            [PNYCacheAssembly assembly],
            [PNYServiceAssembly assembly],
            [PNYAppAssembly assembly],
    ]];

    [componentFactory inject:self];
    [componentFactory makeDefault];

    [TyphoonComponentFactory setFactoryForResolvingUI:componentFactory];
}

@end