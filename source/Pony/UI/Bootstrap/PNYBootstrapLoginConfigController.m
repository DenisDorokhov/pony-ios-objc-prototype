//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapLoginConfigController.h"
#import "PNYBootstrapConfigControllerAbstract+Protected.h"
#import "PNYErrorDto.h"
#import "PNYAlertFactory.h"
#import "PNYBootstrapChildControllerAbstract+Protected.h"
#import "PNYMacros.h"

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

    self.view.userInteractionEnabled = NO;
}

- (void)finishBackgroundActivity
{
    [super finishBackgroundActivity];

    self.view.userInteractionEnabled = YES;
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

        if ([PNYErrorDto fetchErrorFromArray:aErrors withCode:PNYErrorDtoCodeClientOffline] != nil) {
            [self showOfflineAlert];
        } else if ([PNYErrorDto fetchErrorFromArray:aErrors withCode:PNYErrorDtoCodeInvalidCredentials]) {
            [self showCredentialsAlert];
        } else if ([PNYErrorDto fetchErrorFromArray:aErrors withCode:PNYErrorDtoCodeValidation]) {
            [self showValidationAlert];
        } else {
            [self showConnectionAlert];
        }
    }];
}

- (void)showValidationAlert
{
    [self presentViewController:[PNYAlertFactory createOKAlertWithTitle:PNYLocalized(@"bootstrapLoginConfig_validationAlert_title")
                                                                message:PNYLocalized(@"bootstrapLoginConfig_validationAlert_message")]
                       animated:YES completion:nil];
}

- (void)showCredentialsAlert
{
    [self presentViewController:[PNYAlertFactory createOKAlertWithTitle:PNYLocalized(@"bootstrapLoginConfig_credentialsAlert_title")
                                                                message:PNYLocalized(@"bootstrapLoginConfig_credentialsAlert_message")]
                       animated:YES completion:nil];
}

@end