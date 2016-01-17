//
// Created by Denis Dorokhov on 16/01/16.
// Copyright (c) 2016 Denis Dorokhov. All rights reserved.
//

#import "PNYImageDownloadView.h"
#import "PNYSongDownloadService.h"

@interface PNYSongDownloadCell : UITableViewCell <PNYSongDownloadServiceDelegate>

@property (nonatomic, strong) PNYSongDownloadService *songDownloadService;

@property (nonatomic, strong) PNYSongDto *song;

@property (nonatomic, strong) IBOutlet PNYImageDownloadView *artworkDownloadView;

@property (nonatomic, strong) IBOutlet UILabel *songHeaderLabel;
@property (nonatomic, strong) IBOutlet UILabel *songTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel *progressLabel;

@property (nonatomic, strong) IBOutlet UIProgressView *downloadProgressView;

@end