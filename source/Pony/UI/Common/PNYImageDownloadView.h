//
// Created by Denis Dorokhov on 11/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

IB_DESIGNABLE
@interface PNYImageDownloadView : UIView

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@end