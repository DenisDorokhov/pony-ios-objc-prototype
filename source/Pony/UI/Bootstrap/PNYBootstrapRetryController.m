//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapRetryController.h"
#import "PNYMacros.h"

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

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.retryLabel.text = PNYLocalized(@"bootstrapRetry_label");

    [self.retryButton setTitle:PNYLocalized(@"bootstrapRetry_retryButton") forState:UIControlStateNormal];
    [self.otherServerButton setTitle:PNYLocalized(@"bootstrapRetry_otherServerButton") forState:UIControlStateNormal];
}

@end