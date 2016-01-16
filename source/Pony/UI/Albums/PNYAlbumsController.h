//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYArtistDto.h"
#import "PNYRestServiceCached.h"
#import "PNYErrorService.h"
#import "PNYSongDownloadService.h"

@interface PNYAlbumsController : UITableViewController <UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) id <PNYRestServiceCached> restService;
@property (nonatomic, strong) PNYErrorService *errorService;
@property (nonatomic, strong) PNYSongDownloadService *songDownloadService;

@property (nonatomic, strong) PNYArtistDto *artist;

@property (nonatomic) IBInspectable CGFloat albumHeaderHeight;
@property (nonatomic) IBInspectable CGFloat songCellHeight;
@property (nonatomic) IBInspectable CGFloat songCellWithDiscNumberHeight;

- (IBAction)onRefreshRequested;
- (IBAction)onDownloadManagerRequested;

@end