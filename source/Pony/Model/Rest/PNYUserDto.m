//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYUserDto.h"
#import "PNYDtoUtils.h"

@implementation PNYUserDto

#pragma mark - Override

+ (EKObjectMapping *)objectMapping
{
    EKObjectMapping *mapping = [super objectMapping];

    [mapping mapPropertiesFromArray:@[@"name", @"email"]];

    [mapping mapKeyPath:@"creationDate" toProperty:@"creationDate" withValueBlock:^(NSString *aKey, NSNumber *aValue) {
        return [PNYDtoUtils timestampToDate:aValue];
    } reverseBlock:^id(NSDate *aValue) {
        return [PNYDtoUtils dateToTimestamp:aValue];
    }];
    [mapping mapKeyPath:@"updateDate" toProperty:@"updateDate" withValueBlock:^(NSString *aKey, NSNumber *aValue) {
        return [PNYDtoUtils timestampToDate:aValue];
    } reverseBlock:^id(NSDate *aValue) {
        return [PNYDtoUtils dateToTimestamp:aValue];
    }];

    NSDictionary *roles = @{ @"USER": @(PNYRoleDtoUser), @"ADMIN": @(PNYRoleDtoAdmin) };
    [mapping mapKeyPath:@"role" toProperty:@"role" withValueBlock:^(NSString *aKey, id aValue) {
        return aValue != (id)[NSNull null] ? roles[aValue] : @(PNYRoleDtoUser);
    } reverseBlock:^id(id aValue) {
        return aValue != (id)[NSNull null] ? [roles allKeysForObject:aValue].lastObject : @"USER";
    }];

    return mapping;
}

@end