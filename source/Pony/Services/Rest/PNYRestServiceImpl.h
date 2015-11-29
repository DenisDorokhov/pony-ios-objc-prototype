//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestService.h"
#import "PNYTokenPairDao.h"
#import "PNYRestServiceUrlDao.h"

@interface PNYRestServiceImpl : NSObject <PNYRestService>

@property (nonatomic, strong) id <PNYRestServiceUrlDao> urlDao;
@property (nonatomic, strong) id <PNYTokenPairDao> tokenPairDao;

@property (nonatomic) NSInteger maxConcurrentRestRequestCount;
@property (nonatomic) NSInteger maxConcurrentImageRequestCount;
@property (nonatomic) NSInteger maxConcurrentSongRequestCount;

@end