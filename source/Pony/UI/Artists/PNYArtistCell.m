//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYArtistCell.h"
#import "PNYMacros.h"

@implementation PNYArtistCell

#pragma mark - Public

- (void)setArtist:(PNYArtistDto *)aArtist
{
    _artist = aArtist;

    [self updateArtist];
}

#pragma mark - Private

- (void)updateArtist
{
    self.nameLabel.text = self.artist.name != nil ? self.artist.name : PNYLocalized(@"artists_unknownArtist");
}

@end