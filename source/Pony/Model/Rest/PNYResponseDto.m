//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKMapper.h>
#import <EasyMapping/EKRelationshipMapping.h>
#import "PNYResponseDto.h"
#import "PNYErrorDto.h"

@implementation PNYResponseDto

+ (EKObjectMapping *)objectMappingWithDataClass:(Class)aDataClass
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {

        [mapping mapPropertiesFromArray:@[@"version", @"successful"]];
        [mapping hasMany:[PNYErrorDto class] forKeyPath:@"errors"];

        [mapping mapKeyPath:@"data" toProperty:@"data" withValueBlock:^id(NSString *aKey, id aValue) {
            if ([aValue isKindOfClass:[NSArray class]]) {
                return [EKMapper arrayOfObjectsFromExternalRepresentation:aValue
                                                              withMapping:[aDataClass objectMapping]];
            } else {
                return [EKMapper objectFromExternalRepresentation:aValue
                                                      withMapping:[aDataClass objectMapping]];
            }
        }];
    }];
}

@end