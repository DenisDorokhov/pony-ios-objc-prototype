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

@implementation PNYArtistsController
{
@private
    UIRefreshControl *refreshControl;

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

    refreshControl = [[UIRefreshControl alloc] init];

    [refreshControl addTarget:self action:@selector(onRefreshRequested) forControlEvents:UIControlEventValueChanged];

    [self.tableView addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    if (artists == nil) {
        [self requestArtists];
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

- (void)requestArtists
{
    PNYLogInfo(@"Loading artists...");

    [self.restService getArtistsWithSuccess:^(NSArray *aArtists) {

        artists = aArtists;

        PNYLogInfo(@"[%lu] artists loaded.", (unsigned long)artists.count);

        [refreshControl endRefreshing];
        [self.tableView reloadData];

    }                               failure:^(NSArray *aErrors) {

        PNYLogError(@"Could not load artists: %@.", aErrors);

        [self.errorService reportErrors:aErrors];
    }];
}

- (void)onRefreshRequested
{
    [self requestArtists];
}

@end