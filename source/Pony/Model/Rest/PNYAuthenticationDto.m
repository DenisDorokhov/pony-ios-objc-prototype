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
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *aMapping) {

        [aMapping mapPropertiesFromArray:@[@"accessToken", @"refreshToken"]];
        [aMapping hasOne:[PNYUserDto class] forKeyPath:@"user"];

        [aMapping mapKeyPath:@"accessTokenExpiration" toProperty:@"accessTokenExpiration" withValueBlock:^(NSString *aKey, NSNumber *aValue) {
            return [PNYDtoUtils timestampToDate:aValue];
        }       reverseBlock:^id(NSDate *aValue) {
            return [PNYDtoUtils dateToTimestamp:aValue];
        }];
        [aMapping mapKeyPath:@"refreshTokenExpiration" toProperty:@"refreshTokenExpiration" withValueBlock:^(NSString *aKey, NSNumber *aValue) {
            return [PNYDtoUtils timestampToDate:aValue];
        }       reverseBlock:^id(NSDate *aValue) {
            return [PNYDtoUtils dateToTimestamp:aValue];
        }];
    }];
}

@end