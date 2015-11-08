//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAppDelegate.h"
#import "TyphoonBlockComponentFactory.h"
#import "PNYUtilityAssembly.h"
#import "PNYCacheAssembly.h"
#import "PNYServiceAssembly.h"
#import "PNYAppAssembly.h"

@implementation PNYAppDelegate

- (BOOL)application:(UIApplication *)aApplication didFinishLaunchingWithOptions:(NSDictionary *)aLaunchOptions
{
    [self setupTyphoon];

    PNYAssert(self.config != nil);

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Bootstrap" bundle:[NSBundle mainBundle]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [self.config colorValue:@"window.backgroundColor"];
    self.window.tintColor = [self.config colorValue:@"window.tintColor"];
    self.window.rootViewController = [storyboard instantiateInitialViewController];

    [self.window makeKeyAndVisible];

    PNYLogInfo(@"Application started.");

    return YES;
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

    [componentFactory makeDefault];

    [componentFactory inject:self];

    [TyphoonComponentFactory setFactoryForResolvingUI:componentFactory];
}

@end