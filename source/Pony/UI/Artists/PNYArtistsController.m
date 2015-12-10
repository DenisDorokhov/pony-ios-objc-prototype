//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYArtistsController.h"
#import "PNYSegues.h"
#import "PNYMacros.h"
#import "PNYArtistCell.h"

@implementation PNYArtistsController
{
@private
    NSArray *artists;
}

#pragma mark - Public

- (IBAction)onLogoutButtonTouch
{
    [self.authenticationService logoutWithSuccess:nil failure:nil];
}

- (IBAction)onRefreshRequested
{
    [self requestArtists];
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

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.restService != nil);
    PNYAssert(self.authenticationService != nil);
    PNYAssert(self.errorService != nil);
}

- (void)viewWillAppear:(BOOL)aAnimated
{
    [super viewWillAppear:aAnimated];

    [self requestArtists];
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

#pragma mark - Private

- (void)requestArtists
{
    PNYLogInfo(@"Loading artists...");

    [self.restService getArtistsWithSuccess:^(NSArray *aArtists) {

        artists = aArtists;

        [self.refreshControl endRefreshing];
        [self.tableView reloadData];

        PNYLogInfo(@"[%lu] artists loaded.", (unsigned long)artists.count);

    }                               failure:^(NSArray *aErrors) {
        [self.errorService reportErrors:aErrors];
    }];
}

@end