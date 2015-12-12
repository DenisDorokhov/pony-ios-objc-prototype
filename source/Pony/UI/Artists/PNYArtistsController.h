//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAuthenticationService.h"
#import "PNYRestServiceCached.h"
#import "PNYErrorService.h"

@interface PNYArtistsController : UIViewController <UITableViewDataSource, UITableViewDelegate, PNYAuthenticationServiceDelegate>

@property (nonatomic, strong) id <PNYRestServiceCached> restService;
@property (nonatomic, strong) PNYAuthenticationService *authenticationService;
@property (nonatomic, strong) PNYErrorService *errorService;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

- (IBAction)onLogoutButtonTouch;

@end