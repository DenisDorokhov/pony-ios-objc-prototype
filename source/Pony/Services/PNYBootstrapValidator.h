//
// Created by Denis Dorokhov on 05/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYUserSettings.h"
#import "PNYAuthenticationService.h"

@class PNYBootstrapValidator;

@protocol PNYBootstrapValidatorDelegate <NSObject>

- (void)bootstrapValidatorDidStartValidation:(PNYBootstrapValidator *)aBootstrapValidator;
- (void)bootstrapValidatorDidFinishValidation:(PNYBootstrapValidator *)aBootstrapValidator;

- (void)bootstrapValidatorDidRequireRestUrl:(PNYBootstrapValidator *)aBootstrapValidator;
- (void)bootstrapValidatorDidRequireAuthentication:(PNYBootstrapValidator *)aBootstrapValidator;

- (void)bootstrapValidator:(PNYBootstrapValidator *)aBootstrapValidator didFailRequestWithErrors:(NSArray *)aErrors;

@end

@interface PNYBootstrapValidator : NSObject

@property (nonatomic, strong) id <PNYUserSettings> userSettings;
@property (nonatomic, strong) PNYAuthenticationService *authenticationService;

@property (nonatomic, weak) id <PNYBootstrapValidatorDelegate> delegate;

- (void)validate;

@end