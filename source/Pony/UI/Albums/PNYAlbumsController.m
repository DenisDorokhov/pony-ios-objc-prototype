//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAlbumsController.h"
#import "PNYMacros.h"
#import "PNYAlbumSongsDto.h"
#import "PNYSongCell.h"
#import "PNYErrorDto.h"
#import "PNYSegues.h"
#import "PNYAlbumHeaderCell.h"

@interface PNYAlbumsController ()

@property (nonatomic, strong) PNYArtistAlbumsDto *artistAlbums;

@end

@implementation PNYAlbumsController
{
@private
    NSMutableArray *albumDiscsToSongs; // NSMutableArray of NSMutableDictionary (NSNumber -> Array of PNYSongDto)

    id <PNYRestRequest> lastAlbumsRequest;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        self.albumHeaderHeight = 44;
        self.songCellHeight = 44;
        self.songCellWithDiscNumberHeight = 44;
    }
    return self;
}

#pragma mark - Public

- (void)setArtist:(PNYArtistDto *)aArtist
{
    _artist = aArtist;

    if (self.artist != nil) {
        self.title = self.artist.name != nil ? self.artist.name : PNYLocalized(@"common_unknownArtist");
    } else {
        self.title = nil;
    }

    if (self.artist != nil) {
        [self requestAlbumsUsingCache:YES];
    } else {
        [self.tableView reloadData];
    }
}

- (IBAction)onRefreshRequested
{
    if (self.artist != nil) {
        [self requestAlbumsUsingCache:NO];
    } else {
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }
}

- (IBAction)onDownloadManagerRequested
{
    [self performSegueWithIdentifier:PNYSegueAlbumsToDownloadManager sender:self];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.artistAlbums.albums.count;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    PNYAlbumSongsDto *albumSongs = self.artistAlbums.albums[(NSUInteger)aSection];

    return albumSongs.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    PNYAlbumSongsDto *albumSongs = self.artistAlbums.albums[(NSUInteger)aIndexPath.section];
    PNYSongDto *song = albumSongs.songs[(NSUInteger)aIndexPath.row];

    BOOL isCellWithDiscNumber = [self shouldSong:song renderDiscNumberWithAlbumIndex:(NSUInteger)aIndexPath.section];

    PNYSongCell *songCell;
    if (isCellWithDiscNumber) {
        songCell = [aTableView dequeueReusableCellWithIdentifier:@"songCellWithDiscNumber"];
    } else {
        songCell = [aTableView dequeueReusableCellWithIdentifier:@"songCell"];
    }

    [self.appAssembly inject:songCell];

    songCell.song = song;

    return songCell;
}

- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)aSection
{
    PNYAlbumSongsDto *albumSongs = self.artistAlbums.albums[(NSUInteger)aSection];

    PNYAlbumHeaderCell *albumHeaderCell = [aTableView dequeueReusableCellWithIdentifier:@"albumHeader"];

    albumHeaderCell.albumHeader.album = albumSongs.album;

    return albumHeaderCell.contentView;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)aSection
{
    return self.albumHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    PNYAlbumSongsDto *albumSongs = self.artistAlbums.albums[(NSUInteger)aIndexPath.section];
    PNYSongDto *song = albumSongs.songs[(NSUInteger)aIndexPath.row];

    BOOL isCellWithDiscNumber = [self shouldSong:song renderDiscNumberWithAlbumIndex:(NSUInteger)aIndexPath.section];

    return isCellWithDiscNumber ? self.songCellWithDiscNumberHeight : self.songCellHeight;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    [aTableView deselectRowAtIndexPath:aIndexPath animated:YES];

    PNYAlbumSongsDto *albumSongs = self.artistAlbums.albums[(NSUInteger)aIndexPath.section];
    PNYSongDto *song = albumSongs.songs[(NSUInteger)aIndexPath.row];

    if ([self.songDownloadService downloadForSong:song.id] != nil) {
        PNYLogInfo(@"There will be playback.");
    } else {
        if ([self.songDownloadService progressForSong:song.id] != nil) {
            [self.songDownloadService cancelDownloadForSong:song.id];
        } else {
            [self.songDownloadService startDownloadForSong:song];
        }
    }
}

- (NSArray *)tableView:(UITableView *)aTableView editActionsForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    PNYAlbumSongsDto *albumSongs = self.artistAlbums.albums[(NSUInteger)aIndexPath.section];
    PNYSongDto *song = albumSongs.songs[(NSUInteger)aIndexPath.row];

    __weak typeof(self) weakSelf = self;

    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive
                                                                            title:PNYLocalized(@"albums_deleteSong")
                                                                          handler:^(UITableViewRowAction *aAction, NSIndexPath *aActionIndexPath) {

                                                                              [weakSelf.songDownloadService deleteDownloadForSong:song.id];

                                                                              [aTableView setEditing:NO];
                                                                          }];

    return @[deleteAction];
}

- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    PNYAlbumSongsDto *albumSongs = self.artistAlbums.albums[(NSUInteger)aIndexPath.section];
    PNYSongDto *song = albumSongs.songs[(NSUInteger)aIndexPath.row];

    return [self.songDownloadService downloadForSong:song.id] != nil;
}

#pragma mark - <UIPopoverPresentationControllerDelegate>

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)aController
{
    return UIModalPresentationNone;
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.appAssembly != nil);
    PNYAssert(self.restService != nil);
    PNYAssert(self.errorService != nil);
    PNYAssert(self.songDownloadService != nil);
}

- (void)prepareForSegue:(UIStoryboardSegue *)aSegue sender:(id)aSender
{
    if ([aSegue.identifier isEqualToString:PNYSegueAlbumsToDownloadManager]) {
        aSegue.destinationViewController.popoverPresentationController.delegate = self;
    }
}

#pragma mark - Private

- (void)setArtistAlbums:(PNYArtistAlbumsDto *)aArtistAlbums
{
    _artistAlbums = aArtistAlbums;

    albumDiscsToSongs = [NSMutableArray array];

    for (PNYAlbumSongsDto *albumSongs in self.artistAlbums.albums) {

        NSMutableDictionary *discToSongs = [NSMutableDictionary dictionary];

        for (PNYSongDto *song in albumSongs.songs) {

            NSNumber *discNumber = song.discNumber;
            if (discNumber.intValue == 0) {
                discNumber = @1;
            }

            NSMutableArray *discSongs = discToSongs[discNumber];
            if (discSongs == nil) {
                discSongs = [NSMutableArray array];
                discToSongs[discNumber] = discSongs;
            }

            [discSongs addObject:song];
        }

        [albumDiscsToSongs addObject:discToSongs];
    }
}

- (void)requestAlbumsUsingCache:(BOOL)aUseCache
{
    [lastAlbumsRequest cancel];

    lastAlbumsRequest = nil;

    PNYArtistDto *artistToLoad = self.artist;

    PNYLogInfo(@"Loading albums of artist [%@]...", artistToLoad.id);

    lastAlbumsRequest = [self.restService getArtistAlbumsWithArtist:artistToLoad.id.stringValue success:^(PNYArtistAlbumsDto *aArtistAlbums) {

        lastAlbumsRequest = nil;

        self.artistAlbums = aArtistAlbums;

        PNYLogInfo(@"[%lu] albums of artist [%@] loaded.", (unsigned long)self.artistAlbums.albums.count, artistToLoad.id);

        [self.refreshControl endRefreshing];
        [self.tableView reloadData];

    }                                                       failure:^(NSArray *aErrors) {

        if ([PNYErrorDto fetchErrorFromArray:aErrors withCode:PNYErrorDtoCodeClientRequestCancelled] != nil) {
            PNYLogDebug(@"Cancelled loading albums of artist [%@].", artistToLoad.id);
        } else {
            if ([PNYErrorDto fetchErrorFromArray:aErrors withCode:PNYErrorDtoCodeClientOffline] == nil) {

                PNYLogError(@"Could not load albums of artist [%@]: %@.", artistToLoad.id, aErrors);

                [self.errorService reportErrors:aErrors];
            }

            [self.refreshControl endRefreshing];
        }

    }                                                  cacheHandler:^BOOL(PNYArtistAlbumsDto *aCachedArtistAlbums) {

        if (aUseCache && aCachedArtistAlbums != nil) {

            self.artistAlbums = aCachedArtistAlbums;

            PNYLogInfo(@"[%lu] albums of artist [%@] loaded from cache, making a server request...", (unsigned long)self.artistAlbums.albums.count, artistToLoad.id);

            [self.tableView reloadData];
        }

        return YES;
    }];
}

- (BOOL)shouldSong:(PNYSongDto *)aSong renderDiscNumberWithAlbumIndex:(NSUInteger)aAlbumIndex
{
    __block BOOL isCellWithDiscNumber = NO;

    NSDictionary *albumDiscs = albumDiscsToSongs[aAlbumIndex];
    if (albumDiscs.count > 1) {
        [albumDiscs enumerateKeysAndObjectsUsingBlock:^(NSNumber *aDiscNumber, NSArray *aSongs, BOOL *aStop) {
            if (aSongs[0] == aSong) {
                isCellWithDiscNumber = YES;
                *aStop = YES;
            }
        }];
    }

    return isCellWithDiscNumber;
}

@end