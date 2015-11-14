//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYMainController.h"
#import "PNYSegues.h"

@implementation PNYMainController

#pragma mark - Public

- (IBAction)onLogoutButtonTouch
{
    [self.authenticationService logoutWithSuccess:nil failure:nil];
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.authenticationService != nil);
}

- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [self.authenticationService addDelegate:self];
}

- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];

    [self.authenticationService removeDelegate:self];
}

#pragma mark - <PNYAuthenticationService>

- (void)authenticationService:(PNYAuthenticationService *)aAuthenticationService
            didLogOutWithUser:(PNYUserDto *)aUser
{
    [self performSegueWithIdentifier:PNYSegueBootstrapFromMain sender:self];
}

@end