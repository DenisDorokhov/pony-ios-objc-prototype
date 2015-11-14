//
// Created by Denis Dorokhov on 01/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAuthenticationService.h"
#import "NSMutableOrderedSet+PNYNSValue.h"
#import "NSOrderedSet+PNYNSValue.h"
#import "PNYErrorDto.h"

@implementation PNYAuthenticationService
{
@private
    NSMutableOrderedSet *delegates;
    BOOL isRefreshingToken;
}

static const NSTimeInterval STATUS_UPDATE_INTERVAL = 60;
static const NSTimeInterval ACCESS_TOKEN_EXPIRATION_CHECK_INTERVAL = 15;
static const NSTimeInterval REFRESH_TOKEN_TIME_BEFORE_EXPIRATION = 60 * 60;

- (instancetype)init
{
    self = [super init];
    if (self != nil) {

        delegates = [NSMutableOrderedSet orderedSet];

        [self scheduleStatusUpdate];
        [self scheduleAccessTokenExpirationCheck];
    }
    return self;
}

#pragma mark - Public

- (void)addDelegate:(id <PNYAuthenticationServiceDelegate>)aDelegate
{
    [delegates addNonretainedObject:aDelegate];
}

- (void)removeDelegate:(id <PNYAuthenticationServiceDelegate>)aDelegate
{
    [delegates removeNonretainedObject:aDelegate];
}

- (BOOL)authenticated
{
    return self.currentUser != nil;
}

- (void)authenticateWithSuccess:(PNYAuthenticationServiceSuccessBlock)aSuccess
                        failure:(PNYAuthenticationServiceFailureBlock)aFailure
{
    PNYAssert(self.tokenPairDao != nil);
    PNYAssert(self.restService != nil);

    if (self.authenticated) {

        PNYLogWarn(@"User [%@] is already authenticated.", self.currentUser.email);

        if (aSuccess != nil) {
            aSuccess(self.currentUser);
        }

        return;
    }

    PNYLogInfo(@"Authenticating with stored credentials...");

    PNYTokenPair *tokenPair = [self.tokenPairDao fetchTokenPair];

    if (tokenPair != nil) {

        [self updateStatusWithSuccess:^(PNYUserDto *aUser) {

            if (aSuccess != nil) {
                aSuccess(aUser);
            }
            [self propagateAuthentication:aUser];

            [self checkAccessTokenExpirationWithBlock:nil];

        }                     failure:^(NSArray *aErrors) {
            if (aFailure != nil) {
                aFailure(aErrors);
            }
        }];

    } else {

        PNYLogInfo(@"User is not authenticated.");

        if (aSuccess != nil) {
            aSuccess(nil);
        }
    }
}

- (void)authenticateWithCredentials:(PNYCredentialsDto *)aCredentials
                            success:(PNYAuthenticationServiceSuccessBlock)aSuccess
                            failure:(PNYAuthenticationServiceFailureBlock)aFailure
{
    PNYAssert(self.restService != nil);

    if (self.authenticated) {

        PNYLogWarn(@"User is already authenticated, logging out...");

        [self logoutWithSuccess:nil failure:nil];
    }

    PNYLogInfo(@"Authenticating user [%@]...", aCredentials.email);

    [self.restService authenticateWithCredentials:aCredentials success:^(PNYAuthenticationDto *aAuthentication) {

        [self updateAuthentication:aAuthentication];

        PNYLogInfo(@"User [%@] has authenticated.", aAuthentication.user.email);

        if (aSuccess != nil) {
            aSuccess(aAuthentication.user);
        }
        [self propagateAuthentication:aAuthentication.user];

    }                                     failure:^(NSArray *aErrors) {

        PNYLogInfo(@"Authentication failed for user [%@]: %@", aCredentials.email, aErrors);

        if (aFailure != nil) {
            aFailure(aErrors);
        }
    }];
}

- (void)updateStatusWithSuccess:(PNYAuthenticationServiceSuccessBlock)aSuccess
                        failure:(PNYAuthenticationServiceFailureBlock)aFailure
{
    PNYAssert(self.restService != nil);

    PNYLogDebug(@"Updating authentication status...");

    [self.restService getCurrentUserWithSuccess:^(PNYUserDto *aUser) {

        _currentUser = aUser;

        PNYLogVerbose(@"User [%@] is authenticated.", aUser.email);

        if (aSuccess != nil) {
            aSuccess(aUser);
        }
        [self propagateStatusUpdate:aUser];

    }                                   failure:^(NSArray *aErrors) {

        if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeClientRequestFailed, PNYErrorDtoCodeClientOffline]] != nil) {

            PNYLogError(@"Could not update authentication status (client error): %@.", aErrors);

            if (aFailure != nil) {
                aFailure(aErrors);
            }

        } else if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeAccessDenied]]) {

            if (self.authenticated && !isRefreshingToken) {

                [self refreshTokenWithSuccess:^(PNYAuthenticationDto *aAuthentication) {
                    if (aSuccess != nil) {
                        aSuccess(aAuthentication.user);
                    }
                }                     failure:^(NSArray *aRefreshTokenErrors) {
                    if (aFailure != nil) {
                        aFailure(aErrors);
                    }
                }];

            } else {
                if (aFailure != nil) {
                    aFailure(aErrors);
                }
            }

        } else {

            PNYLogError(@"Could not update authentication status (server error): %@.", aErrors);

            if (aFailure != nil) {
                aFailure(aErrors);
            }
        }
    }];
}

- (void)logoutWithSuccess:(PNYAuthenticationServiceSuccessBlock)aSuccess
                  failure:(PNYAuthenticationServiceFailureBlock)aFailure
{
    PNYAssert(self.restService != nil);

    if (self.currentUser != nil) {

        PNYLogInfo(@"Logging out user [%@]...", self.currentUser.email);

        [self.restService logoutWithSuccess:^(PNYUserDto *aUser) {

            PNYLogInfo(@"User [%@] has logged out.", aUser.email);

            if (aSuccess != nil) {
                aSuccess(aUser);
            }

        }                           failure:^(NSArray *aErrors) {

            PNYLogError(@"Could not log out: %@.", aErrors);

            if (aFailure != nil) {
                aFailure(aErrors);
            }
        }];
    } else {

        PNYLogInfo(@"Could not log out: user is not authenticated.");

        if (aFailure != nil) {
            aFailure(@[[PNYErrorDto errorWithCode:PNYErrorDtoCodeAccessDenied
                                             text:@"Access denied." arguments:nil]]);
        }
    }

    PNYUserDto *lastUser = self.currentUser;

    [self clearAuthentication];
    if (lastUser != nil) {
        [self propagateLogOut:lastUser];
    }
}

#pragma mark - Private

- (void)updateAuthentication:(PNYAuthenticationDto *)aAuthentication
{
    PNYAssert(self.tokenPairDao != nil);

    PNYTokenPair *tokenPair = [PNYTokenPair new];

    tokenPair.accessToken = aAuthentication.accessToken;
    tokenPair.accessTokenExpiration = aAuthentication.accessTokenExpiration;

    tokenPair.refreshToken = aAuthentication.refreshToken;
    tokenPair.refreshTokenExpiration = aAuthentication.refreshTokenExpiration;

    [self.tokenPairDao storeTokenPair:tokenPair];

    _currentUser = aAuthentication.user;
}

- (void)clearAuthentication
{
    PNYAssert(self.tokenPairDao != nil);

    [self.tokenPairDao removeTokenPair];

    _currentUser = nil;
}

- (void)refreshTokenWithSuccess:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                        failure:(PNYAuthenticationServiceFailureBlock)aFailure
{
    PNYAssert(self.tokenPairDao != nil);

    PNYLogInfo(@"Refreshing access token...");

    PNYTokenPair *tokenPair = [self.tokenPairDao fetchTokenPair];

    if (tokenPair != nil) {

        isRefreshingToken = YES;

        [self.restService refreshTokenWithSuccess:^(PNYAuthenticationDto *aAuthentication) {

            [self updateAuthentication:aAuthentication];

            isRefreshingToken = NO;

            PNYLogInfo(@"Token for user [%@] has been refreshed.", aAuthentication.user.email);

            if (aSuccess != nil) {
                aSuccess(aAuthentication);
            }

        }                                 failure:^(NSArray *aErrors) {

            isRefreshingToken = NO;

            PNYLogError(@"Could not refresh token: %@", aErrors);

            if (aFailure != nil) {
                aFailure(aErrors);
            }

            if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeAccessDenied]]) {

                PNYUserDto *lastUser = self.currentUser;

                [self clearAuthentication];
                if (lastUser != nil) {
                    [self propagateLogOut:lastUser];
                }
            }
        }];

    } else {

        PNYLogError(@"Could not refresh token: no token found.");

        if (aFailure != nil) {
            aFailure(@[[PNYErrorDto errorWithCode:PNYErrorDtoCodeAccessDenied
                                             text:@"Access denied." arguments:nil]]);
        }
    }
}

- (void)checkAccessTokenExpirationWithBlock:(void (^)())aCompletion
{
    PNYAssert(self.tokenPairDao != nil);

    PNYTokenPair *tokenPair = [self.tokenPairDao fetchTokenPair];

    if (!isRefreshingToken && tokenPair != nil &&
            [tokenPair.accessTokenExpiration timeIntervalSinceNow] <= REFRESH_TOKEN_TIME_BEFORE_EXPIRATION) {

        [self refreshTokenWithSuccess:^(PNYAuthenticationDto *aAuthentication) {
            if (aCompletion != nil) {
                aCompletion();
            }
        }                     failure:^(NSArray *aErrors) {
            if (aCompletion != nil) {
                aCompletion();
            }
        }];

    } else {
        if (aCompletion != nil) {
            aCompletion();
        }
    }
}

- (void)scheduleAccessTokenExpirationCheck
{
    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ACCESS_TOKEN_EXPIRATION_CHECK_INTERVAL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.authenticated) {
            [weakSelf checkAccessTokenExpirationWithBlock:^{
                [self scheduleAccessTokenExpirationCheck];
            }];
        } else {
            [self scheduleAccessTokenExpirationCheck];
        }
    });
}

- (void)scheduleStatusUpdate
{
    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(STATUS_UPDATE_INTERVAL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.authenticated) {
            [weakSelf updateStatusWithSuccess:^(PNYUserDto *aUser) {
                [weakSelf scheduleStatusUpdate];
            }                         failure:^(NSArray *aErrors) {
                [weakSelf scheduleStatusUpdate];
            }];
        } else {
            [weakSelf scheduleStatusUpdate];
        }
    });
}

- (void)propagateAuthentication:(PNYUserDto *)aUser
{
    // TODO: remove casting when AppCode finally supports this
    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYAuthenticationServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(authenticationService:didAuthenticateWithUser:)]) {
            [aObject authenticationService:self didAuthenticateWithUser:aUser];
        }
    }];
}

- (void)propagateStatusUpdate:(PNYUserDto *)aUser
{
    // TODO: remove casting when AppCode finally supports this
    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYAuthenticationServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(authenticationService:didUpdateStatusWithUser:)]) {
            [aObject authenticationService:self didUpdateStatusWithUser:aUser];
        }
    }];
}

- (void)propagateLogOut:(PNYUserDto *)aUser
{
    // TODO: remove casting when AppCode finally supports this
    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYAuthenticationServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(authenticationService:didLogOutWithUser:)]) {
            [aObject authenticationService:self didLogOutWithUser:aUser];
        }
    }];
}

@end