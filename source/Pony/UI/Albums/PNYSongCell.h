//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYSongDto.h"

@interface PNYSongCell : UITableViewCell

@property (nonatomic, strong) PNYSongDto *song;

@property (nonatomic, strong) IBOutlet UILabel *numberLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;

@end