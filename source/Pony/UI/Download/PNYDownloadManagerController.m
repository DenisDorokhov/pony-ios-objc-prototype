//
// Created by Denis Dorokhov on 16/01/16.
// Copyright (c) 2016 Denis Dorokhov. All rights reserved.
//

#import "PNYDownloadManagerController.h"
#import "PNYMacros.h"
#import "PNYSongDownloadCell.h"

@implementation PNYDownloadManagerController
{
@private
    NSMutableArray *downloadingSongs;
}

- (void)dealloc
{
    [self.songDownloadService removeDelegate:self];
}

#pragma mark - Public

- (IBAction)onCancelAllButtonTouch
{
    for (PNYSongDto *song in downloadingSongs) {
        [self.songDownloadService cancelDownloadForSong:song.id];
    }
}

#pragma mark - <PNYSongDownloadServiceDelegate>

- (void)songDownloadService:(PNYSongDownloadService *)aService didStartSongDownload:(NSNumber *)aSongId
{
    [self reloadDownloadingSongs];
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didCancelSongDownload:(NSNumber *)aSongId
{
    [self reloadDownloadingSongs];
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didFailSongDownload:(NSNumber *)aSongId errors:(NSArray *)aErrors
{
    [self reloadDownloadingSongs];
}

- (void)songDownloadService:(PNYSongDownloadService *)aService didCompleteSongDownload:(id <PNYSongDownload>)aSongDownload
{
    [self reloadDownloadingSongs];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return downloadingSongs.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    PNYSongDownloadCell *songDownloadCell = [aTableView dequeueReusableCellWithIdentifier:@"songDownloadCell"];

    [self.appAssembly inject:songDownloadCell];

    songDownloadCell.song = downloadingSongs[(NSUInteger)aIndexPath.row];

    return songDownloadCell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    [aTableView deselectRowAtIndexPath:aIndexPath animated:YES];

    PNYSongDto *song = downloadingSongs[(NSUInteger)aIndexPath.row];

    [self.songDownloadService cancelDownloadForSong:song.id];
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.appAssembly != nil);
    PNYAssert(self.songDownloadService != nil);
}

- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    [self.songDownloadService addDelegate:self];

    [self reloadDownloadingSongs];
}

- (void)viewDidDisappear:(BOOL)aAnimated
{
    [super viewDidDisappear:aAnimated];

    [self.songDownloadService removeDelegate:self];
}

#pragma mark - Private

- (void)reloadDownloadingSongs
{
    downloadingSongs = [NSMutableArray array];
    for (id <PNYSongDownloadProgress> progress in [self.songDownloadService allProgresses]) {
        [downloadingSongs addObject:progress.song];
    }

    self.cancelAllButton.enabled = downloadingSongs.count > 0;

    [self.tableView reloadData];
}

@end