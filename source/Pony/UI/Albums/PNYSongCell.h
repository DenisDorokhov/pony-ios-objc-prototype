//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYSongDto.h"

@interface PNYSongCell : UITableViewCell

@property (nonatomic, strong) PNYSongDto *song;

@property (nonatomic, strong) IBOutlet UILabel *trackNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;

@end