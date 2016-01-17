//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <MBCircularProgressBar/MBCircularProgressBarView.h>
#import "PNYSongDto.h"
#import "PNYSongDownloadService.h"

@interface PNYSongCell : UITableViewCell <PNYSongDownloadServiceDelegate>

@property (nonatomic, strong) PNYSongDownloadService *songDownloadService;

@property (nonatomic, strong) PNYSongDto *song;

@property (nonatomic, strong) IBOutlet UILabel *trackNumberLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *durationLabel;

@property (nonatomic, strong) IBOutlet UIImageView *statusImage;
@property (nonatomic, strong) IBOutlet MBCircularProgressBarView *progressBar;

@end