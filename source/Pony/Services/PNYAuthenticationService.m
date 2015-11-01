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
}

static const NSTimeInterval STATUS_UPDATE_INTERVAL = 60;
static const NSTimeInterval ACCESS_TOKEN_EXPIRATION_CHECK_INTERVAL = 15;
static const NSTimeInterval REFRESH_TOKEN_TIME_BEFORE_EXPIRATION = 60 * 60;

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        delegates = [NSMutableOrderedSet orderedSet];
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

- (BOOL)isAuthenticated
{
    return self.currentUser != nil;
}

- (void)initializeWithSuccess:(PNYAuthenticationServiceSuccessBlock)aSuccess
                      failure:(PNYAuthenticationServiceFailureBlock)aFailure
{
    PNYAssert(self.tokenPairDao != nil);
    PNYAssert(self.restService != nil);

    PNYLogInfo(@"Initilizing...");

    PNYTokenPair *tokenPair = [self.tokenPairDao fetchTokenPair];

    if (tokenPair != nil) {

        [self updateStatusWithSuccess:^(PNYUserDto *aUser) {

            [self checkAccessTokenExpiration];

            if (aSuccess != nil) {
                aSuccess(aUser);
            }
            [self propagateInitialization:aUser];

        } failure:^(NSArray *aErrors) {

            if (aFailure != nil) {
                aFailure(aErrors);
            }
            [self propagateInitialization:nil];
        }];

    } else {

        PNYLogInfo(@"User is not authenticated.");

        if (aSuccess != nil) {
            aSuccess(nil);
        }
        [self propagateInitialization:nil];
    }

    [self scheduleStatusUpdate];
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

    } failure:^(NSArray *aErrors) {

        if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeClientRequestFailed, PNYErrorDtoCodeClientOffline]] != nil) {

            PNYLogError(@"Could not update authentication status (client error): %@.", aErrors);

            if (aFailure != nil) {
                aFailure(aErrors);
            }

        } else if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeAccessDenied]]) {

            [self refreshTokenWithSuccess:^(PNYAuthenticationDto *aAuthentication) {
                if (aSuccess != nil) {
                    aSuccess(aAuthentication.user);
                }
            } failure:^(NSArray *aRefreshTokenErrors) {
                if (aFailure != nil) {
                    aFailure(aErrors);
                }
            }];

        } else {

            PNYLogError(@"Could not update authentication status (server error): %@.", aErrors);

            [self clearAuthenticationWithLogOutPropagation:YES];

            if (aFailure != nil) {
                aFailure(aErrors);
            }
        }
    }];
}

- (void)authenticateWithCredentials:(PNYCredentialsDto *)aCredentials
                            success:(PNYAuthenticationServiceSuccessBlock)aSuccess
                            failure:(PNYAuthenticationServiceFailureBlock)aFailure
{
    PNYAssert(self.restService != nil);

    if (self.isAuthenticated) {
        [self clearAuthenticationWithLogOutPropagation:YES];
    }

    PNYLogInfo(@"Authenticating user [%@]...", aCredentials.email);

    [self.restService authenticate:aCredentials success:^(PNYAuthenticationDto *aAuthentication) {

        [self updateAuthentication:aAuthentication];

        PNYLogInfo(@"User [%@] has authenticated.", aAuthentication.user.email);

        if (aSuccess != nil) {
            aSuccess(aAuthentication.user);
        }
        [self propagateAuthentication:aAuthentication.user];

    } failure:^(NSArray *aErrors) {

        PNYLogInfo(@"Authentication failed for user [%@]: %@", aCredentials.email, aErrors);

        if (aFailure != nil) {
            aFailure(aErrors);
        }
    }];
}

- (void)logoutWithSuccess:(PNYAuthenticationServiceSuccessBlock)aSuccess
                  failure:(PNYAuthenticationServiceFailureBlock)aFailure
{
    PNYAssert(self.restService != nil);

    if (self.currentUser != nil) {
        PNYLogInfo(@"Logging out user [%@]...", self.currentUser.email);
    } else {
        PNYLogWarn(@"Logging out unknown user...");
    }

    [self.restService logoutWithSuccess:^(PNYUserDto *aUser) {

        PNYLogInfo(@"User [%@] has logged out.", aUser.email);

        if (aSuccess != nil) {
            aSuccess(aUser);
        }

    } failure:^(NSArray *aErrors) {

        PNYLogError(@"Could not log out: %@.", aErrors);

        if (aFailure != nil) {
            aFailure(aErrors);
        }
    }];

    [self clearAuthenticationWithLogOutPropagation:YES];
}

#pragma mark - Private

- (void)updateAuthentication:(PNYAuthenticationDto *)aAuthentication
{
    PNYAssert(self.tokenPairDao != nil);

    PNYTokenPair *tokenPair = [[PNYTokenPair alloc] init];

    tokenPair.accessToken = aAuthentication.accessToken;
    tokenPair.accessTokenExpiration = aAuthentication.accessTokenExpiration;

    tokenPair.refreshToken = aAuthentication.refreshToken;
    tokenPair.refreshTokenExpiration = aAuthentication.refreshTokenExpiration;

    [self.tokenPairDao storeTokenPair:tokenPair];

    _currentUser = aAuthentication.user;
}

- (void)clearAuthenticationWithLogOutPropagation:(BOOL)aLogOutPropagation
{
    PNYAssert(self.tokenPairDao != nil);

    [self.tokenPairDao removeTokenPair];

    _currentUser = nil;

    if (aLogOutPropagation) {
        [self propagateLogOut:_currentUser];
    }
}

- (void)refreshTokenWithSuccess:(void(^)(PNYAuthenticationDto *aAuthentication))aSuccess
                        failure:(PNYAuthenticationServiceFailureBlock)aFailure
{
    PNYAssert(self.tokenPairDao != nil);

    PNYLogInfo(@"Refreshing access token...");

    PNYTokenPair *tokenPair = [self.tokenPairDao fetchTokenPair];

    if (tokenPair != nil) {

        [self.restService refreshTokenWithSuccess:^(PNYAuthenticationDto *aAuthentication) {

            [self updateAuthentication:aAuthentication];

            PNYLogInfo(@"Token for user [%@] has been refreshed.", aAuthentication.user.email);

            if (aSuccess != nil) {
                aSuccess(aAuthentication);
            }

        } failure:^(NSArray *aErrors) {

            PNYLogError(@"Could not refresh token: %@", aErrors);

            if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeClientRequestFailed, PNYErrorDtoCodeClientOffline]] == nil) {
                [self clearAuthenticationWithLogOutPropagation:NO];
            }

            if (aFailure != nil) {
                aFailure(aErrors);
            }
        }];

    } else {

        PNYLogError(@"Could not refresh token: no token found.");

        [self clearAuthenticationWithLogOutPropagation:YES];

        if (aFailure != nil) {
            aFailure(@[[PNYErrorDto errorWithCode:PNYErrorDtoCodeAccessDenied
                                             text:@"Access denied." arguments:nil]]);
        }
    }
}

- (void)checkAccessTokenExpiration
{
    PNYAssert(self.tokenPairDao != nil);

    BOOL scheduleCheck = YES;

    PNYTokenPair *tokenPair = [self.tokenPairDao fetchTokenPair];

    if (tokenPair != nil) {
        if ((tokenPair.accessTokenExpiration.timeIntervalSince1970 - [NSDate date].timeIntervalSince1970) <= REFRESH_TOKEN_TIME_BEFORE_EXPIRATION) {

            scheduleCheck = NO;

            [self refreshTokenWithSuccess:^(PNYAuthenticationDto *aAuthentication) {
                [self scheduleAccessTokenExpirationCheck];
            } failure:^(NSArray *aErrors) {
                [self scheduleAccessTokenExpirationCheck];
            }];
        }
    }

    if (scheduleCheck) {
        [self scheduleAccessTokenExpirationCheck];
    }
}

- (void)scheduleAccessTokenExpirationCheck
{
    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ACCESS_TOKEN_EXPIRATION_CHECK_INTERVAL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf checkAccessTokenExpiration];
    });
}

- (void)scheduleStatusUpdate
{
    __weak typeof(self) weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(STATUS_UPDATE_INTERVAL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.isAuthenticated) {
            [weakSelf updateStatusWithSuccess:^(PNYUserDto *aUser) {
                [weakSelf scheduleStatusUpdate];
            } failure:^(NSArray *aErrors) {
                [weakSelf scheduleStatusUpdate];
            }];
        } else {
            [weakSelf scheduleStatusUpdate];
        }
    });
}

- (void)propagateInitialization:(PNYUserDto *)aUser
{
    PNYLogInfo(@"Initialization complete.");

    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYAuthenticationServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(authenticationService:didInitializeWithUser:)]) {
            [aObject authenticationService:self didInitializeWithUser:aUser];
        }
    }];
}

- (void)propagateAuthentication:(PNYUserDto *)aUser
{
    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYAuthenticationServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(authenticationService:didAuthenticateWithUser:)]) {
            [aObject authenticationService:self didAuthenticateWithUser:aUser];
        }
    }];
}

- (void)propagateStatusUpdate:(PNYUserDto *)aUser
{
    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYAuthenticationServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(authenticationService:didUpdateStatusWithUser:)]) {
            [aObject authenticationService:self didUpdateStatusWithUser:aUser];
        }
    }];
}

- (void)propagateLogOut:(PNYUserDto *)aUser
{
    [(NSOrderedSet *)delegates enumerateNonretainedObjectsUsingBlock:^(id <PNYAuthenticationServiceDelegate> aObject, NSUInteger aIndex, BOOL *aStop) {
        if ([aObject respondsToSelector:@selector(authenticationService:didLogOutWithUser:)]) {
            [aObject authenticationService:self didLogOutWithUser:aUser];
        }
    }];
}

@end