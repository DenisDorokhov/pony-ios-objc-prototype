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

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.retryLabel.text = PNYLocalized(@"bootstrap.retry.retryLabel");

    [self.retryButton setTitle:PNYLocalized(@"bootstrap.retry.retryButton") forState:UIControlStateNormal];
}

@end