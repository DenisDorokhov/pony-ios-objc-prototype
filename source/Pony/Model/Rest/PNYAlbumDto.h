//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAbstractDto.h"
#import "PNYArtistDto.h"

@interface PNYAlbumDto : PNYAbstractDto

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSNumber *year;

@property (nonatomic) NSNumber *artwork;
@property (nonatomic, strong) NSString *artworkUrl;

@property (nonatomic, strong) PNYArtistDto *artist;

@end