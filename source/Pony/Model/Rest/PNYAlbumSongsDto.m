//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAlbumSongsDto.h"
#import "PNYSongDto.h"

@implementation PNYAlbumSongsDto

#pragma mark - <EKMappingProtocol>

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping hasOne:[PNYAlbumDto class] forKeyPath:@"album"];
        [mapping hasMany:[PNYSongDto class] forKeyPath:@"songs"];
    }];
}

@end