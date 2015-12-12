//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAlbumsController.h"
#import "PNYMacros.h"
#import "PNYAlbumSongsDto.h"
#import "PNYSongCell.h"
#import "PNYAlbumHeader.h"
#import "PNYErrorDto.h"

@implementation PNYAlbumsController
{
@private
    UIRefreshControl *refreshControl;

    PNYArtistAlbumsDto *artistAlbums;

    id <PNYRestRequest> lastAlbumsRequest;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        self.headerHeight = 44;
        self.cellHeight = 44;
    }
    return self;
}

#pragma mark - Public

- (void)setArtist:(PNYArtistDto *)aArtist
{
    _artist = aArtist;

    [self updateArtist];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return artistAlbums.albums.count;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    PNYAlbumSongsDto *albumSongs = artistAlbums.albums[(NSUInteger)aSection];

    return albumSongs.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    PNYAlbumSongsDto *albumSongs = artistAlbums.albums[(NSUInteger)aIndexPath.section];

    PNYSongCell *songCell = [aTableView dequeueReusableCellWithIdentifier:@"songCell"];

    songCell.song = albumSongs.songs[(NSUInteger)aIndexPath.row];

    return songCell;
}

- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)aSection
{
    PNYAlbumSongsDto *albumSongs = artistAlbums.albums[(NSUInteger)aSection];

    PNYAlbumHeader *albumHeader = [aTableView dequeueReusableCellWithIdentifier:@"albumHeader"];

    albumHeader.album = albumSongs.album;

    return albumHeader;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)aSection
{
    return self.headerHeight;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    return self.cellHeight;
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.restService != nil);

    PNYAssert(self.tableView != nil);

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    refreshControl = [[UIRefreshControl alloc] init];

    [refreshControl addTarget:self action:@selector(onRefreshRequested) forControlEvents:UIControlEventValueChanged];

    [self.tableView addSubview:refreshControl];
}

#pragma mark - Private

- (void)updateArtist
{
    if (self.artist != nil) {
        self.title = self.artist.name != nil ? self.artist.name : PNYLocalized(@"albums_unknownArtist");
    } else {
        self.title = nil;
    }

    if (self.artist != nil) {
        [self requestAlbums];
    } else {
        [self.tableView reloadData];
    }
}

- (void)requestAlbums
{
    [lastAlbumsRequest cancel];

    lastAlbumsRequest = nil;

    PNYArtistDto *artistToLoad = self.artist;

    PNYLogInfo(@"Loading albums of artist [%@]...", artistToLoad.id);

    lastAlbumsRequest = [self.restService getArtistAlbumsWithArtist:artistToLoad.id.stringValue success:^(PNYArtistAlbumsDto *aArtistAlbums) {

        lastAlbumsRequest = nil;

        artistAlbums = aArtistAlbums;

        PNYLogInfo(@"[%lu] albums of artist [%@] loaded.", (unsigned long)artistAlbums.albums.count, artistToLoad.id);

        [refreshControl endRefreshing];
        [self.tableView reloadData];

    } failure:^(NSArray *aErrors) {
        if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeClientRequestCancelled]] != nil) {
            PNYLogError(@"Cancelled loading albums of artist [%@].", artistToLoad.id);
        } else {

            PNYLogError(@"Could not load albums of artist [%@]: %@.", artistToLoad.id, aErrors);

            [self.errorService reportErrors:aErrors];
        }
    }];
}

- (void)onRefreshRequested
{
    if (self.artist != nil) {
        [self requestAlbums];
    } else {
        [refreshControl endRefreshing];
        [self.tableView reloadData];
    }
}

@end