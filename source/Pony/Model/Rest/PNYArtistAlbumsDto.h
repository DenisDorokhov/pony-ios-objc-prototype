//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYArtistDto.h"

@interface PNYArtistAlbumsDto : NSObject <EKMappingProtocol>

@property (nonatomic, strong) PNYArtistDto *artist;
@property (nonatomic, strong) NSArray *albums;

@end