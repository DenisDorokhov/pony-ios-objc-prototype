//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapConfigControllerAbstract.h"
#import "PNYAuthenticationService.h"

@interface PNYBootstrapLoginConfigController : PNYBootstrapConfigControllerAbstract <UITextFieldDelegate>

@property (nonatomic, strong) PNYAuthenticationService *authenticationService;

@property (nonatomic, strong) IBOutlet UITextField *emailText;
@property (nonatomic, strong) IBOutlet UITextField *passwordText;

- (IBAction)onLoginButtonTouch;
- (IBAction)onOtherServerButtonTouch;

@end