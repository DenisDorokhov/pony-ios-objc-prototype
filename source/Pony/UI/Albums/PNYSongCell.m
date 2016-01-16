//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYSongCell.h"
#import "PNYMacros.h"
#import "PNYDtoUtils.h"

@implementation PNYSongCell

#pragma mark - Public

- (void)setSong:(PNYSongDto *)aAlbum
{
    _song = aAlbum;

    self.trackNumberLabel.text = self.song.trackNumber.stringValue;
    self.nameLabel.text = self.song.name != nil ? self.song.name : PNYLocalized(@"albums_unknownSong");
    self.durationLabel.text = [PNYDtoUtils formatDurationFromSeconds:self.song.duration.doubleValue];
}

@end