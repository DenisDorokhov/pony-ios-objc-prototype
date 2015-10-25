//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestService.h"
#import "PNYRestServiceUrlProvider.h"
#import "PNYTokenPairDao.h"

@interface PNYRestServiceImpl : NSObject <PNYRestService>

@property (nonatomic, strong) id <PNYRestServiceUrlProvider> urlProvider;

@property (nonatomic, strong) id <PNYTokenPairDao> tokenPairDao;

@property (nonatomic) NSInteger maxConcurrentRequestCount;

@end