//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapStepController.h"

@interface PNYBootstrapAuthenticationController : UIViewController <PNYBootstrapStepController>

@property (nonatomic, strong) IBOutlet UILabel *loginLabel;
@property (nonatomic, strong) IBOutlet UILabel *passwordLabel;
@property (nonatomic, strong) IBOutlet UITextField *loginText;
@property (nonatomic, strong) IBOutlet UITextField *passwordText;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;

@end