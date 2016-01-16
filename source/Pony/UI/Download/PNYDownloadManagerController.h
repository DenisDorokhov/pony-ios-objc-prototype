//
// Created by Denis Dorokhov on 16/01/16.
// Copyright (c) 2016 Denis Dorokhov. All rights reserved.
//

#import "PNYSongDownloadService.h"
#import "PNYAppAssembly.h"

@interface PNYDownloadManagerController : UITableViewController <PNYSongDownloadServiceDelegate>

@property (nonatomic, strong) PNYAppAssembly *appAssembly;

@property (nonatomic, strong) PNYSongDownloadService *songDownloadService;

@end