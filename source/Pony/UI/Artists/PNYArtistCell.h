//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYArtistDto.h"

@interface PNYArtistCell : UITableViewCell

@property (nonatomic, strong) PNYArtistDto *artist;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@end