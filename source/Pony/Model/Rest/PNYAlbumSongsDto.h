//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAlbumDto.h"

@interface PNYAlbumSongsDto : NSObject <EKMappingProtocol>

@property (nonatomic, strong) PNYAlbumDto *album;
@property (nonatomic, strong) NSArray *songs;

@end