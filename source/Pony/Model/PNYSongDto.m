//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYSongDto.h"
#import "PNYObjectUtils.h"

@implementation PNYSongDto

- (NSComparisonResult)compare:(PNYSongDto *)aSong
{
    NSComparisonResult result = NSOrderedSame;

    if (![self isEqual:aSong]) {

        result = [PNYObjectUtils compare:self.artistName with:aSong.artistName];

        if (result == 0) {
            result = [PNYObjectUtils compare:self.album.year with:aSong.album.year];
        }
        if (result == 0) {
            result = [PNYObjectUtils compare:self.album.name with:aSong.album.name];
        }

        if (result == 0) {

            NSNumber *discNumber1 = self.discNumber != nil ? self.discNumber : @(1);
            NSNumber *discNumber2 = aSong.discNumber != nil ? aSong.discNumber : @(1);

            result = [PNYObjectUtils compare:discNumber1 with:discNumber2];
        }
        if (result == 0) {

            NSNumber *trackNumber1 = self.trackNumber != nil ? self.trackNumber : @(1);
            NSNumber *trackNumber2 = aSong.trackNumber != nil ? aSong.trackNumber : @(1);

            result = [PNYObjectUtils compare:trackNumber1 with:trackNumber2];
        }
        if (result == 0) {
            result = [PNYObjectUtils compare:self.name with:aSong.name];
        }
    }

    return result;
}

@end