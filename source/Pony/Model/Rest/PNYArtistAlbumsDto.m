//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYArtistAlbumsDto.h"
#import "PNYAlbumSongsDto.h"

@implementation PNYArtistAlbumsDto

#pragma mark - <EKMappingProtocol>

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *aMapping) {
        [aMapping hasOne:[PNYArtistDto class] forKeyPath:@"artist"];
        [aMapping hasMany:[PNYAlbumSongsDto class] forKeyPath:@"albums"];
    }];
}

@end