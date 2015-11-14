//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapConfigControllerAbstract.h"
#import "PNYBootstrapConfigControllerAbstract+Protected.h"
#import "PNYAlertFactory.h"

@implementation PNYBootstrapConfigControllerAbstract

@synthesize delegate = _delegate;

#pragma mark - Protected

- (void)startBackgroundActivity
{
    [self.delegate bootstrapConfigControllerDidStartBackgroundActivity:self];
}

- (void)finishBackgroundActivity
{
    [self.delegate bootstrapConfigControllerDidFinishBackgroundActivity:self];
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