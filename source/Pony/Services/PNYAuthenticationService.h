//
// Created by Denis Dorokhov on 01/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYUserDto.h"
#import "PNYCredentialsDto.h"
#import "PNYTokenPairDao.h"
#import "PNYRestService.h"

@class PNYAuthenticationService;

@protocol PNYAuthenticationServiceDelegate <NSObject>

@optional

- (void)authenticationService:(PNYAuthenticationService *)aAuthenticationService
      didAuthenticateWithUser:(PNYUserDto *)aUser;

- (void)authenticationService:(PNYAuthenticationService *)aAuthenticationService
      didUpdateStatusWithUser:(PNYUserDto *)aUser;

- (void)authenticationService:(PNYAuthenticationService *)aAuthenticationService
            didLogOutWithUser:(PNYUserDto *)aUser;

@end

typedef void (^PNYAuthenticationServiceSuccessBlock)(PNYUserDto *aUser);
typedef void (^PNYAuthenticationServiceFailureBlock)(NSArray *aErrors);

@interface PNYAuthenticationService : NSObject

@property (nonatomic, strong) id <PNYTokenPairDao> tokenPairDao;
@property (nonatomic, strong) id <PNYRestService> restService;

@property (nonatomic, readonly) BOOL authenticated;
@property (nonatomic, readonly) PNYUserDto *currentUser;

- (void)addDelegate:(id <PNYAuthenticationServiceDelegate>)aDelegate;
- (void)removeDelegate:(id <PNYAuthenticationServiceDelegate>)aDelegate;

- (void)authenticateWithCredentials:(PNYCredentialsDto *)aCredentials
                            success:(PNYAuthenticationServiceSuccessBlock)aSuccess
                            failure:(PNYAuthenticationServiceFailureBlock)aFailure;

- (void)updateStatusWithSuccess:(PNYAuthenticationServiceSuccessBlock)aSuccess
                        failure:(PNYAuthenticationServiceFailureBlock)aFailure;

- (void)logoutWithSuccess:(PNYAuthenticationServiceSuccessBlock)aSuccess
                  failure:(PNYAuthenticationServiceFailureBlock)aFailure;

@end