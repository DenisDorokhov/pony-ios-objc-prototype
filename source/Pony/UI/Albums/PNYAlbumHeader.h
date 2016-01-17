//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAlbumDto.h"
#import "PNYImageDownloadView.h"

@interface PNYAlbumHeader : UIView

@property (nonatomic, strong) PNYAlbumDto *album;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *yearLabel;
@property (nonatomic, strong) IBOutlet PNYImageDownloadView *artworkDownloadView;

@end