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
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *aMapping) {

        [aMapping mapPropertiesFromArray:@[@"version", @"successful"]];
        [aMapping hasMany:[PNYErrorDto class] forKeyPath:@"errors"];

        [aMapping mapKeyPath:@"data" toProperty:@"data" withValueBlock:^id(NSString *aKey, id aValue) {
            if (aValue == nil) {
                return nil;
            }
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