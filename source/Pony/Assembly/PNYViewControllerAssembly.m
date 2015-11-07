//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYViewControllerAssembly.h"
#import "PNYBootstrapViewController.h"

@implementation PNYViewControllerAssembly

- (PNYBootstrapViewController *)bootstrapViewController
{
    return [TyphoonDefinition withClass:[PNYBootstrapViewController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(bootstrapService) with:[self.serviceAssembly bootstrapService]];
    }];
}

@end