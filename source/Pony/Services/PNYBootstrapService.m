//
// Created by Denis Dorokhov on 05/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapService.h"
#import "PNYUserSettingsKeys.h"

@implementation PNYBootstrapService
{
@private
    BOOL isBootstrapping;
}

#pragma mark - Public

- (void)bootstrap
{
    PNYAssert(self.authenticationService != nil);

    if (!isBootstrapping) {

        [self.delegate bootstrapServiceDidStartBootstrap:self];

        if ([self restUrlExists]) {
            if (self.authenticationService.authenticated) {

                [self.delegate bootstrapServiceDidFinishBootstrap:self];

            } else {

                [self.authenticationService authenticateWithSuccess:^(PNYUserDto *aUser) {
                    if (aUser != nil) {
                        [self.delegate bootstrapServiceDidFinishBootstrap:self];
                    } else {
                        [self.delegate bootstrapServiceDidRequireAuthentication:self];
                    }
                }                                           failure:^(NSArray *aErrors) {
                    [self.delegate bootstrapService:self didFailRequestWithErrors:aErrors];
                }];
            }
        } else {
            [self.delegate bootstrapServiceDidRequireRestUrl:self];
        }
    }
}

#pragma mark - Private

- (BOOL)restUrlExists
{
    return ([self.userSettings settingForKey:PNYUserSettingsKeyRestProtocol] != nil &&
            [self.userSettings settingForKey:PNYUserSettingsKeyRestUrl] != nil);
}

@end