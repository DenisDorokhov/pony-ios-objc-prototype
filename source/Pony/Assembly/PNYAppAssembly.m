//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAppAssembly.h"
#import "PNYAppDelegate.h"
#import "PNYBootstrapController.h"
#import "PNYBootstrapLoginConfigController.h"
#import "PNYBootstrapServerConfigController.h"
#import "PNYMainController.h"

@implementation PNYAppAssembly

#pragma mark - Private

- (PNYAppDelegate *)appDelegate
{
    return [TyphoonDefinition withClass:[PNYAppDelegate class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(config) with:[self.utilityAssembly config]];
    }];
}

- (PNYMainController *)mainController
{
    return [TyphoonDefinition withClass:[PNYMainController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(authenticationService) with:[self.serviceAssembly authenticationService]];
    }];
}

- (PNYBootstrapController *)bootstrapController
{
    return [TyphoonDefinition withClass:[PNYBootstrapController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(bootstrapService) with:[self.serviceAssembly bootstrapService]];
    }];
}

- (PNYBootstrapServerConfigController *)bootstrapServerController
{
    return [TyphoonDefinition withClass:[PNYBootstrapServerConfigController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(restServiceUrlDao) with:[self.serviceAssembly restServiceUrlDao]];
        [aDefinition injectProperty:@selector(restService) with:[self.serviceAssembly restServiceCached]];
    }];
}

- (PNYBootstrapLoginConfigController *)bootstrapAuthenticationController
{
    return [TyphoonDefinition withClass:[PNYBootstrapLoginConfigController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(authenticationService) with:[self.serviceAssembly authenticationService]];
    }];
}

@end