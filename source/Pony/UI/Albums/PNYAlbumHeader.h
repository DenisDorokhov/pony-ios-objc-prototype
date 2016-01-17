//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYImageDownloadView.h"
#import "PNYSongDownloadService.h"
#import "PNYAlbumSongsDto.h"

@interface PNYAlbumHeader : UIView <UIActionSheetDelegate>

@property (nonatomic, strong) PNYSongDownloadService *songDownloadService;

@property (nonatomic, strong) PNYAlbumSongsDto *albumSongs;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *yearLabel;
@property (nonatomic, strong) IBOutlet PNYImageDownloadView *artworkDownloadView;

- (IBAction)onButtonTouch;

@end