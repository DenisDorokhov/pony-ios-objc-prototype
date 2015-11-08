//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <Typhoon/TyphoonAssembly.h>
#import "PNYConfig.h"
#import "PNYEventBus.h"
#import "PNYUserSettings.h"
#import "PNYCacheAssembly.h"
#import "PNYRestServiceCached.h"
#import "PNYBootstrapService.h"

@interface PNYServiceAssembly : TyphoonAssembly

@property (nonatomic, strong) PNYCacheAssembly *cacheAssembly;

- (id <PNYConfig>)config;

- (PNYEventBus *)eventBus;

- (id <PNYUserSettings>)userSettings;

- (id <PNYRestServiceCached>)restServiceCached;

- (PNYBootstrapService *)bootstrapService;
- (PNYAuthenticationService *)authenticationService;

@end