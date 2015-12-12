//
// Created by Denis Dorokhov on 12/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYSongCellWithDiscNumber.h"
#import "PNYMacros.h"

@implementation PNYSongCellWithDiscNumber

#pragma mark - Override

- (void)setSong:(PNYSongDto *)aSong
{
    [super setSong:aSong];

    self.discNumberLabel.text = PNYLocalized(@"albums_discNumber", self.song.discNumber.intValue >= 1 ? self.song.discNumber : @1);
}

@end