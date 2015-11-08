//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYConfig.h"

@interface PNYAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) id <PNYConfig> config;

@property (strong, nonatomic) UIWindow *window;

@end