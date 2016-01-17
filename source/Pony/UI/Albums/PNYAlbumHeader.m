//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAlbumHeader.h"
#import "PNYMacros.h"

@implementation PNYAlbumHeader

#pragma mark - Public

- (void)setAlbumSongs:(PNYAlbumSongsDto *)aAlbumSongs
{
    _albumSongs = aAlbumSongs;

    self.nameLabel.text = self.albumSongs.album.name != nil ? self.albumSongs.album.name : PNYLocalized(@"common_unknownAlbum");
    self.yearLabel.text = self.albumSongs.album.year.stringValue;
    self.artworkDownloadView.imageUrl = self.albumSongs.album.artworkUrl;
}

- (IBAction)onButtonTouch
{
    PNYAssert(self.songDownloadService != nil);

    BOOL downloadsExist = NO;
    BOOL allSongsDownloaded = YES;

    for (PNYSongDto *song in self.albumSongs.songs) {
        if ([self.songDownloadService downloadForSong:song.id] != nil) {
            downloadsExist = YES;
        } else {
            allSongsDownloaded = NO;
        }
    }

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:PNYLocalized(@"albumHeader_buttonCancel")
                                               destructiveButtonTitle:downloadsExist ? PNYLocalized(@"albumHeader_buttonDelete") : nil
                                                    otherButtonTitles:allSongsDownloaded ? nil : PNYLocalized(@"albumHeader_buttonDownload"), nil];

    [actionSheet showInView:self];
}

#pragma mark - <UIActionSheetDelegate>

- (void)actionSheet:(UIActionSheet *)aActionSheet clickedButtonAtIndex:(NSInteger)aButtonIndex
{
    PNYAssert(self.songDownloadService != nil);

    for (PNYSongDto *song in self.albumSongs.songs) {
        if (aButtonIndex == aActionSheet.destructiveButtonIndex) {
            if ([self.songDownloadService progressForSong:song.id] == nil) {
                if ([self.songDownloadService progressForSong:song.id] == nil) {
                    [self.songDownloadService deleteDownloadForSong:song.id];
                }
            } else {
                [self.songDownloadService cancelDownloadForSong:song.id];
            }
        } else if (aButtonIndex != aActionSheet.cancelButtonIndex) {
            if ([self.songDownloadService downloadForSong:song.id] == nil &&
                    [self.songDownloadService progressForSong:song.id] == nil) {
                [self.songDownloadService startDownloadForSong:song];
            }
        }
    }
}

@end