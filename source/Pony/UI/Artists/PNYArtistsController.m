//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYArtistsController.h"
#import "PNYSegues.h"
#import "PNYMacros.h"
#import "PNYArtistCell.h"
#import "PNYAlbumsController.h"
#import "PNYAlertFactory.h"
#import "PNYErrorDto.h"

@implementation PNYArtistsController
{
@private
    NSArray *artists;

    PNYArtistDto *selectedArtist;
}

#pragma mark - Public

- (IBAction)onLogoutButtonTouch
{
    [self presentViewController:[PNYAlertFactory createOKCancelAlertWithTitle:PNYLocalized(@"artists_logoutAlert_title")
                                                                      message:PNYLocalized(@"artists_logoutAlert_message")
                                                                    okHandler:^{
                                                                        [self.authenticationService logoutWithSuccess:nil failure:nil];
                                                                    }]
                       animated:YES completion:nil];
}


- (IBAction)onRefreshRequested
{
    [self requestArtistsUsingCache:NO];
}

#pragma mark - <PNYAuthenticationService>

- (void)authenticationService:(PNYAuthenticationService *)aAuthenticationService
            didLogOutWithUser:(PNYUserDto *)aUser
{
    [self performSegueWithIdentifier:PNYSegueBootstrapFromMain sender:self];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection
{
    return artists.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    PNYArtistCell *artistCell = [aTableView dequeueReusableCellWithIdentifier:@"artistCell"];

    artistCell.artist = artists[(NSUInteger)aIndexPath.row];

    return artistCell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)aIndexPath
{
    selectedArtist = artists[(NSUInteger)aIndexPath.row];

    [aTableView deselectRowAtIndexPath:aIndexPath animated:YES];

    [self performSegueWithIdentifier:PNYSegueArtistsToAlbums sender:self];
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.restService != nil);
    PNYAssert(self.authenticationService != nil);
    PNYAssert(self.errorService != nil);

    PNYAssert(self.tableView != nil);

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    if (artists == nil) {
        [self requestArtistsUsingCache:YES];
    }
}

- (void)viewDidAppear:(BOOL)aAnimated
{
    [super viewDidAppear:aAnimated];

    [self.authenticationService addDelegate:self];
}

- (void)viewWillDisappear:(BOOL)aAnimated
{
    [super viewWillDisappear:aAnimated];

    [self.authenticationService removeDelegate:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)aSegue sender:(id)aSender
{
    if ([aSegue.identifier isEqualToString:PNYSegueArtistsToAlbums]) {

        PNYAlbumsController *albumsController = (id)aSegue.destinationViewController;

        albumsController.artist = selectedArtist;
    }
}

#pragma mark - Private

- (void)requestArtistsUsingCache:(BOOL)aUseCache
{
    PNYLogInfo(@"Loading artists...");

    [self.restService getArtistsWithSuccess:^(NSArray *aArtists) {

        artists = aArtists;

        PNYLogInfo(@"[%lu] artists loaded.", (unsigned long)artists.count);

        [self.refreshControl endRefreshing];
        [self.tableView reloadData];

    }                               failure:^(NSArray *aErrors) {

        if ([PNYErrorDto fetchErrorFromArray:aErrors withCode:PNYErrorDtoCodeClientOffline] == nil) {

            PNYLogError(@"Could not load artists: %@.", aErrors);

            [self.errorService reportErrors:aErrors];
        }

        [self.refreshControl endRefreshing];

    }                          cacheHandler:^BOOL(NSArray *aCachedArtists) {

        if (aUseCache && aCachedArtists != nil) {

            artists = aCachedArtists;

            PNYLogInfo(@"[%lu] artists loaded from cache, making a server request...", (unsigned long)artists.count);

            [self.tableView reloadData];
        }

        return YES;
    }];
}

@end