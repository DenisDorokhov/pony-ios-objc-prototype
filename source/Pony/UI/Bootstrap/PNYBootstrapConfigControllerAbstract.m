//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapConfigControllerAbstract.h"
#import "PNYBootstrapConfigControllerAbstract+Protected.h"
#import "PNYAlertFactory.h"

@implementation PNYBootstrapConfigControllerAbstract
{
@private
    BOOL _active;
}

@synthesize delegate = _delegate;

#pragma mark - <PNYBootstrapConfigController>

- (BOOL)active
{
    return _active;
}

- (void)setActive:(BOOL)aActive
{
    if (_active != aActive) {

        _active = aActive;

        if (_active) {
            [self activate];
        } else {
            [self passivate];
        }
    }
}

#pragma mark - Protected

- (void)activate
{
    // Do nothing by default.
}

- (void)passivate
{
    // Do nothing by default.
}

- (void)startBackgroundActivity
{
    [self.delegate bootstrapConfigControllerDidStartBackgroundActivity:self];
}

- (void)finishBackgroundActivity
{
    [self.delegate bootstrapConfigControllerDidFinishBackgroundActivity:self];
}

- (void)showValidationAlert
{
    [self presentViewController:[PNYAlertFactory createOKAlertWithTitle:PNYLocalized(@"bootstrapConfig_validationAlert_title")
                                                                message:PNYLocalized(@"bootstrapConfig_validationAlert_message")]
                       animated:YES completion:nil];
}

- (void)showConnectionAlert
{
    [self presentViewController:[PNYAlertFactory createOKAlertWithTitle:PNYLocalized(@"bootstrapConfig_connectionAlert_title")
                                                                message:PNYLocalized(@"bootstrapConfig_connectionAlert_message")]
                       animated:YES completion:nil];
}

- (void)showOfflineAlert
{
    [self presentViewController:[PNYAlertFactory createOKAlertWithTitle:PNYLocalized(@"bootstrapConfig_offlineAlert_title")
                                                                message:PNYLocalized(@"bootstrapConfig_offlineAlert_message")]
                       animated:YES completion:nil];
}

@end