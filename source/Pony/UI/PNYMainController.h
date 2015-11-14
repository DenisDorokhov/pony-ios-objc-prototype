//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAuthenticationService.h"

@interface PNYMainController : UIViewController <PNYAuthenticationServiceDelegate>

@property (nonatomic, strong) PNYAuthenticationService *authenticationService;

- (IBAction)onLogoutButtonTouch;

@end