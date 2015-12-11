//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYArtistDto.h"
#import "PNYRestServiceCached.h"
#import "PNYErrorService.h"

@interface PNYAlbumsController : UITableViewController

@property (nonatomic, strong) id <PNYRestServiceCached> restService;
@property (nonatomic, strong) PNYErrorService *errorService;

@property (nonatomic, strong) PNYArtistDto *artist;

@property (nonatomic) IBInspectable CGFloat headerHeight;
@property (nonatomic) IBInspectable CGFloat cellHeight;

- (IBAction)onRefreshRequested;

@end