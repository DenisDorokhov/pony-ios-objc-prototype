//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <Typhoon/TyphoonAssembly.h>
#import "PNYCacheAssembly.h"
#import "PNYRestServiceCached.h"
#import "PNYBootstrapService.h"
#import "PNYEventBus.h"
#import "PNYUtilityAssembly.h"

@interface PNYServiceAssembly : TyphoonAssembly

@property (nonatomic, strong) PNYUtilityAssembly *utilityAssembly;
@property (nonatomic, strong) PNYCacheAssembly *cacheAssembly;

- (id <PNYRestServiceCached>)restServiceCached;

- (PNYBootstrapService *)bootstrapService;
- (PNYAuthenticationService *)authenticationService;

@end