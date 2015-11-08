//
// Created by Denis Dorokhov on 05/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapService.h"

@implementation PNYBootstrapService
{
@private
    BOOL isBootstrapping;
}

#pragma mark - Public

- (void)bootstrap
{
    PNYAssert(self.restServiceUrlDao != nil);
    PNYAssert(self.restService != nil);
    PNYAssert(self.authenticationService != nil);

    if (!isBootstrapping) {

        [self.delegate bootstrapServiceDidStartBootstrap:self];

        if ([self.restServiceUrlDao fetchUrl] != nil) {
            [self validateRestService];
        } else {
            [self.delegate bootstrapServiceDidRequireRestUrl:self];
        }
    }
}

#pragma mark - Private

- (void)validateRestService
{
    [self.delegate bootstrapServiceDidStartBackgroundActivity:self];

    [self.restService getInstallationWithSuccess:^(PNYInstallationDto *aInstallation) {
        if (self.authenticationService.authenticated) {

            isBootstrapping = NO;

            [self.delegate bootstrapServiceDidFinishBootstrap:self];

        } else {
            [self validateAuthentication];
        }
    }                                    failure:^(NSArray *aErrors) {

        isBootstrapping = NO;

        [self.delegate bootstrapService:self didFailRestServiceRequestWithErrors:aErrors];
    }];
}

- (void)validateAuthentication
{
    [self.authenticationService authenticateWithSuccess:^(PNYUserDto *aUser) {

        isBootstrapping = NO;

        if (aUser != nil) {
            [self.delegate bootstrapServiceDidFinishBootstrap:self];
        } else {
            [self.delegate bootstrapServiceDidRequireAuthentication:self];
        }
    }                                           failure:^(NSArray *aErrors) {

        isBootstrapping = NO;

        [self.delegate bootstrapService:self didFailAuthenticationRequestWithErrors:aErrors];
    }];
}

@end