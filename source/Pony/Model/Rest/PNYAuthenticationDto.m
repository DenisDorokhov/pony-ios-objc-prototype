//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAuthenticationDto.h"

@implementation PNYAuthenticationDto

#pragma mark - Override

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {

        [mapping mapPropertiesFromArray:@[@"accessToken", @"refreshToken"]];
        [mapping hasOne:[PNYUserDto class] forKeyPath:@"user"];

        [mapping mapKeyPath:@"accessTokenExpiration" toProperty:@"accessTokenExpiration" withValueBlock:^(NSString *aKey, NSNumber *aValue) {
            return [NSDate dateWithTimeIntervalSince1970:[aValue doubleValue]];
        }      reverseBlock:^id(NSDate *aValue) {
            return @([aValue timeIntervalSince1970]);
        }];
        [mapping mapKeyPath:@"refreshTokenExpiration" toProperty:@"refreshTokenExpiration" withValueBlock:^(NSString *aKey, NSNumber *aValue) {
            return [NSDate dateWithTimeIntervalSince1970:[aValue doubleValue]];
        }      reverseBlock:^id(NSDate *aValue) {
            return @([aValue timeIntervalSince1970]);
        }];
    }];
}

@end