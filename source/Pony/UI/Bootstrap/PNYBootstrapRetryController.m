//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapRetryController.h"

@implementation PNYBootstrapRetryController

#pragma mark - Public

- (IBAction)onRetryButtonTouch
{
    [self.delegate bootstrapRetryControllerDidRequestRetry:self];
}

- (IBAction)onOtherServerButtonTouch
{
    [self.delegate bootstrapRetryControllerDidRequestOtherServer:self];
}

@end