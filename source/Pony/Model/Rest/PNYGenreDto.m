//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYGenreDto.h"

@implementation PNYGenreDto

#pragma mark - Override

+ (EKObjectMapping *)objectMapping
{
    EKObjectMapping *mapping = [super objectMapping];

    [mapping mapPropertiesFromArray:@[@"name", @"artwork", @"artworkUrl"]];

    return mapping;
}

@end