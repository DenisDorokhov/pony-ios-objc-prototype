//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapAuthenticationController.h"

@implementation PNYBootstrapAuthenticationController

@synthesize delegate = _delegate;

#pragma mark - Public

- (IBAction)onLoginButtonTouch
{
    [self authenticate];
}

#pragma mark - <PNYBootstrapStepController>

- (void)reset
{
    self.loginText.text = @"";
    self.passwordText.text = @"";
}

- (void)retry
{
    // TODO: implement
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    if (aTextField == self.loginText) {
        [self.passwordText becomeFirstResponder];
    } else if (aTextField == self.passwordText) {
        [self.passwordText resignFirstResponder];
        [self authenticate];
    }

    return YES;
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.authenticationService != nil);

    self.loginLabel.text = PNYLocalized(@"bootstrapAuthenticationLoginLabel");
    self.passwordLabel.text = PNYLocalized(@"bootstrapAuthenticationPasswordLabel");

    [self.loginButton setTitle:PNYLocalized(@"bootstrapAuthenticationLoginButton") forState:UIControlStateNormal];
}

#pragma mark - Private

- (void)authenticate
{
    // TODO: implement
}

@end