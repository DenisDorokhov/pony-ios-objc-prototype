//
// Created by Denis Dorokhov on 05/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapService.h"
#import "PNYErrorDto.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "PNYMacros.h"

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

        PNYLogInfo(@"Bootstrapping...");

        isBootstrapping = YES;

        [self.delegate bootstrapServiceDidStartBootstrap:self];

        AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];

        if (reachabilityManager.networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {

            PNYLogDebug(@"Waiting for network status...");

            __weak AFNetworkReachabilityManager *weakReachabilityManager = reachabilityManager;

            [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

                PNYLogDebug(@"Network status updated.");

                [self doBootstrap];

                [weakReachabilityManager setReachabilityStatusChangeBlock:nil];
            }];
            [reachabilityManager startMonitoring];

        } else {
            [self doBootstrap];
        }

    } else {
        PNYLogWarn(@"Could not bootstrap: already bootstrapping.");
    }
}

- (void)clearBootstrapData
{
    PNYLogInfo(@"Clearing bootstrap data.");

    [self.authenticationService logoutWithSuccess:nil failure:nil];
    [self.restServiceUrlDao removeUrl];
}

#pragma mark - Private

- (void)doBootstrap
{
    if ([self.restServiceUrlDao fetchUrl] != nil) {

        [self validateRestService];

    } else {

        isBootstrapping = NO;

        PNYLogInfo(@"Bootstrapping requires server URL.");

        [self.delegate bootstrapServiceDidRequireRestUrl:self];
    }
}

- (void)validateRestService
{
    [self.delegate bootstrapServiceDidStartBackgroundActivity:self];

    [self.restService getInstallationWithSuccess:^(PNYInstallationDto *aInstallation) {
        if (self.authenticationService.authenticated) {

            isBootstrapping = NO;

            [self propagateDidFinishBootstrap];

        } else {
            [self validateAuthentication];
        }
    }                                    failure:^(NSArray *aErrors) {

        isBootstrapping = NO;

        PNYLogError(@"Could not validate server: %@.", aErrors);

        [self.delegate bootstrapService:self didFailWithErrors:aErrors];
    }];
}

- (void)validateAuthentication
{
    [self.authenticationService updateStatusWithSuccess:^(PNYUserDto *aUser) {

        isBootstrapping = NO;

        [self propagateDidFinishBootstrap];

    }                                           failure:^(NSArray *aErrors) {

        isBootstrapping = NO;

        if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeAccessDenied]]) {
            [self.delegate bootstrapServiceDidRequireAuthentication:self];
        } else {
            [self.delegate bootstrapService:self didFailWithErrors:aErrors];
        }
    }];
}

- (void)propagateDidFinishBootstrap
{
    PNYLogInfo(@"Bootstrap finished.");

    [self.delegate bootstrapServiceDidFinishBootstrap:self];
}

@end