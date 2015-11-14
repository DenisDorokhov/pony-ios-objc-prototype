//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapLoginConfigController.h"
#import "PNYBootstrapConfigControllerAbstract+Protected.h"
#import "PNYErrorDto.h"
#import "PNYAlertFactory.h"

@implementation PNYBootstrapLoginConfigController

#pragma mark - Public

- (IBAction)onLoginButtonTouch
{
    [self authenticate];
}

- (void)onOtherServerButtonTouch
{
    [self.delegate bootstrapConfigControllerDidRequestOtherServer:self];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    if (aTextField == self.emailText) {
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

    self.emailLabel.text = PNYLocalized(@"bootstrapLoginConfig_emailLabel");
    self.passwordLabel.text = PNYLocalized(@"bootstrapLoginConfig_passwordLabel");

    [self.loginButton setTitle:PNYLocalized(@"bootstrapLoginConfig_loginButton") forState:UIControlStateNormal];
    [self.otherServerButton setTitle:PNYLocalized(@"bootstrapLoginConfig_otherServerButton") forState:UIControlStateNormal];
}

- (void)activate
{
    [super activate];

    self.emailText.text = @"";
    self.passwordText.text = @"";
}

- (void)startBackgroundActivity
{
    [super startBackgroundActivity];

    self.emailText.enabled = NO;
    self.passwordText.enabled = NO;
    self.loginButton.enabled = NO;
    self.otherServerButton.enabled = NO;
}

- (void)finishBackgroundActivity
{
    [super finishBackgroundActivity];

    self.emailText.enabled = YES;
    self.passwordText.enabled = YES;
    self.loginButton.enabled = YES;
    self.otherServerButton.enabled = YES;
}

#pragma mark - Private

- (void)authenticate
{
    PNYCredentialsDto *credentials = [PNYCredentialsDto new];

    credentials.email = self.emailText.text;
    credentials.password = self.passwordText.text;

    [self startBackgroundActivity];

    [self.authenticationService authenticateWithCredentials:credentials success:^(PNYUserDto *aUser) {

        [self finishBackgroundActivity];

        [self.delegate bootstrapConfigControllerDidRequestBootstrap:self];

    }                                               failure:^(NSArray *aErrors) {

        [self finishBackgroundActivity];

        if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeClientOffline]] != nil) {
            [self showOfflineAlert];
        } else if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeInvalidCredentials]]) {
            [self showCredentialsAlert];
        } else if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeValidation]]) {
            [self showValidationAlert];
        } else {
            [self showConnectionAlert];
        }
    }];
}

- (void)showCredentialsAlert
{
    [self presentViewController:[PNYAlertFactory createOKAlertWithTitle:PNYLocalized(@"bootstrapLoginConfig_credentialsAlert_title")
                                                                message:PNYLocalized(@"bootstrapLoginConfig_credentialsAlert_message")]
                       animated:YES completion:nil];
}

@end