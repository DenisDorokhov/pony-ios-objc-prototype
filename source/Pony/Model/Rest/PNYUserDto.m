//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYUserDto.h"

@implementation PNYUserDto

#pragma mark - Override

+ (EKObjectMapping *)objectMapping
{
    EKObjectMapping *mapping = [super objectMapping];

    [mapping mapPropertiesFromArray:@[@"name", @"email"]];

    [mapping mapKeyPath:@"creationDate" toProperty:@"creationDate" withValueBlock:^(NSString *aKey, NSNumber *aValue) {
        return [NSDate dateWithTimeIntervalSince1970:[aValue doubleValue]];
    } reverseBlock:^id(NSDate *aValue) {
        return @([aValue timeIntervalSince1970]);
    }];
    [mapping mapKeyPath:@"updateDate" toProperty:@"updateDate" withValueBlock:^(NSString *aKey, NSNumber *aValue) {
        return [NSDate dateWithTimeIntervalSince1970:[aValue doubleValue]];
    } reverseBlock:^id(NSDate *aValue) {
        return @([aValue timeIntervalSince1970]);
    }];

    NSDictionary *roles = @{ @"USER": @(PNYRoleDtoUser), @"ADMIN": @(PNYRoleDtoAdmin) };
    [mapping mapKeyPath:@"role" toProperty:@"role" withValueBlock:^(NSString *key, id value) {
        return roles[value];
    } reverseBlock:^id(id value) {
        return [roles allKeysForObject:value].lastObject;
    }];

    return mapping;
}

@end