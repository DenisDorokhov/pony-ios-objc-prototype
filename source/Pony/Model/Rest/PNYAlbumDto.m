//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAlbumDto.h"

@implementation PNYAlbumDto

#pragma mark - Override

+ (EKObjectMapping *)objectMapping
{
    EKObjectMapping *mapping = [super objectMapping];

    [mapping mapPropertiesFromArray:@[@"name", @"year", @"artwork", @"artworkUrl"]];
    [mapping hasOne:[PNYArtistDto class] forKeyPath:@"artist"];

    return mapping;
}

@end