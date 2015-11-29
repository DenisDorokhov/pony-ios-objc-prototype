//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAbstractDto.h"
#import "PNYAlbumDto.h"
#import "PNYGenreDto.h"

@interface PNYSongDto : PNYAbstractDto

@property (nonatomic, strong) NSDate *updateDate;

@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSNumber *duration;
@property (nonatomic, strong) NSNumber *discNumber;
@property (nonatomic, strong) NSNumber *trackNumber;

@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) PNYAlbumDto *album;
@property (nonatomic, strong) PNYGenreDto *genre;

@end