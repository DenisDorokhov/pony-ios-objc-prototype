//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAlbumHeader.h"
#import "PNYMacros.h"

@implementation PNYAlbumHeader

#pragma mark - Public

- (void)setAlbum:(PNYAlbumDto *)aAlbum
{
    _album = aAlbum;

    self.nameLabel.text = self.album.name != nil ? self.album.name : PNYLocalized(@"albums_unknownAlbum");
    self.yearLabel.text = self.album.year.stringValue;
    self.artworkDownloadView.imageUrl = self.album.artworkUrl;
}

@end