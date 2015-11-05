//
// Created by Denis Dorokhov on 05/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapValidator.h"
#import "PNYUserSettingsKeys.h"

@implementation PNYBootstrapValidator
{
@private
    BOOL isValidating;
}

#pragma mark - Public

- (void)validate
{
    PNYAssert(self.authenticationService != nil);

    if (!isValidating) {

        [self.delegate bootstrapValidatorDidStartValidation:self];

        if ([self restUrlExists]) {

            [self.authenticationService initializeWithSuccess:^(PNYUserDto *aUser) {
                if (aUser != nil) {
                    [self.delegate bootstrapValidatorDidFinishValidation:self];
                } else {
                    [self.delegate bootstrapValidatorDidRequireAuthentication:self];
                }
            } failure:^(NSArray *aErrors) {
                [self.delegate bootstrapValidator:self didFailRequestWithErrors:aErrors];
            }];

        } else {
            [self.delegate bootstrapValidatorDidRequireRestUrl:self];
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