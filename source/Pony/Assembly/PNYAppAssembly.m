//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAppAssembly.h"
#import "PNYAppDelegate.h"
#import "PNYBootstrapController.h"

@implementation PNYAppAssembly

#pragma mark - Private

- (PNYAppDelegate *)appDelegate
{
    return [TyphoonDefinition withClass:[PNYAppDelegate class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(config) with:[self.utilityAssembly config]];
    }];
}

- (PNYBootstrapController *)bootstrapViewController
{
    return [TyphoonDefinition withClass:[PNYBootstrapController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(bootstrapService) with:[self.serviceAssembly bootstrapService]];
    }];
}

@end