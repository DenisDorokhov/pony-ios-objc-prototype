//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYSongCell.h"
#import "PNYMacros.h"
#import "PNYDtoUtils.h"

@implementation PNYSongCell

- (void)dealloc
{
    [self.songDownloadService removeDelegate:self];
}

#pragma mark - Public

- (void)setSongDownloadService:(PNYSongDownloadService *)aSongDownloadService
{
    [_songDownloadService removeDelegate:self];

    _songDownloadService = aSongDownloadService;

    [_songDownloadService addDelegate:self];
}

- (void)setSong:(PNYSongDto *)aAlbum
{
    _song = aAlbum;

    self.trackNumberLabel.text = self.song.trackNumber.stringValue;
    self.nameLabel.text = self.song.name != nil ? self.song.name : PNYLocalized(@"common_unknownSong");
    self.durationLabel.text = [PNYDtoUtils formatDurationFromSeconds:self.song.duration.doubleValue];

    [self updateStatus];
}

#pragma mark - <PNYSongDownloadServiceDelegate>

- (void)songDownloadService:(PNYSongDownloadService *)aService didStartSongDownload:(NSNumber *)aSongId
{
    if ([aSongId isEqualToNumber:self.song.id]) {
        [self updateStatus];
    }
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didProgressSongDownload:(id <PNYSongDownloadProgress>)aProgress
{
    if ([aProgress.song.id isEqualToNumber:self.song.id]) {
        [self updateStatus];
    }
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didCancelSongDownload:(NSNumber *)aSongId
{
    if ([aSongId isEqualToNumber:self.song.id]) {
        [self updateStatus];
    }
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didFailSongDownload:(NSNumber *)aSongId errors:(NSArray *)aErrors
{
    if ([aSongId isEqualToNumber:self.song.id]) {
        [self updateStatus];
    }
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didCompleteSongDownload:(id <PNYSongDownload>)aSongDownload
{
    if ([aSongDownload.songId isEqualToNumber:self.song.id]) {
        [self updateStatus];
    }
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didDeleteSongDownload:(NSNumber *)aSongId
{
    if ([aSongId isEqualToNumber:self.song.id]) {
        [self updateStatus];
    }
}

#pragma mark - Private

- (void)updateStatus
{
    PNYAssert(self.songDownloadService != nil);

    if ([self.songDownloadService downloadForSong:self.song.id] != nil) {

        self.statusImage.hidden = NO;
        self.statusImage.image = [UIImage imageNamed:@"song-stored.png"];

        self.progressBar.hidden = YES;

    } else {

        id <PNYSongDownloadProgress> progress = [self.songDownloadService progressForSong:self.song.id];

        if (progress != nil) {

            self.statusImage.hidden = YES;

            self.progressBar.hidden = NO;
            self.progressBar.value = progress.value * 100.0f;

        } else {

            self.statusImage.hidden = NO;
            self.statusImage.image = [UIImage imageNamed:@"song-download.png"];

            self.progressBar.hidden = YES;
        }
    }
}

@end