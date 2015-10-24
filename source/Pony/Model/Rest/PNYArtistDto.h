//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAbstractDto.h"

@interface PNYArtistDto : PNYAbstractDto

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *artwork;
@property (nonatomic, strong) NSString *artworkUrl;

@end