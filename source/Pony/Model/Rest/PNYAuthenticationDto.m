//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAuthenticationDto.h"
#import "PNYDtoUtils.h"

@implementation PNYAuthenticationDto

#pragma mark - Override

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {

        [mapping mapPropertiesFromArray:@[@"accessToken", @"refreshToken"]];
        [mapping hasOne:[PNYUserDto class] forKeyPath:@"user"];

        [mapping mapKeyPath:@"accessTokenExpiration" toProperty:@"accessTokenExpiration" withValueBlock:^(NSString *aKey, NSNumber *aValue) {
            return [PNYDtoUtils timestampToDate:aValue];
        }      reverseBlock:^id(NSDate *aValue) {
            return [PNYDtoUtils dateToTimestamp:aValue];
        }];
        [mapping mapKeyPath:@"refreshTokenExpiration" toProperty:@"refreshTokenExpiration" withValueBlock:^(NSString *aKey, NSNumber *aValue) {
            return [PNYDtoUtils timestampToDate:aValue];
        }      reverseBlock:^id(NSDate *aValue) {
            return [PNYDtoUtils dateToTimestamp:aValue];
        }];
    }];
}

@end