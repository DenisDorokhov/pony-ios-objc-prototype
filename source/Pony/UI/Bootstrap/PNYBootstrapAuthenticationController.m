//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapAuthenticationController.h"

@implementation PNYBootstrapAuthenticationController

@synthesize delegate = _delegate;

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.loginLabel.text = PNYLocalized(@"bootstrap.login.loginLabel");
    self.passwordLabel.text = PNYLocalized(@"bootstrap.login.passwordLabel");

    [self.loginButton setTitle:PNYLocalized(@"bootstrap.login.passwordLabel") forState:UIControlStateNormal];
}

@end