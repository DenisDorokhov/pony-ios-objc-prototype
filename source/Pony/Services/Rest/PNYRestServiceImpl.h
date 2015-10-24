//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestService.h"
#import "PNYUserSettings.h"
#import "PNYTokenPairDao.h"

@interface PNYRestServiceImpl : NSObject <PNYRestService>

@property (nonatomic, strong) id <PNYUserSettings> userSettings;

@property (nonatomic, strong) id <PNYTokenPairDao> tokenPairDao;

@property (nonatomic) NSInteger maxConcurrentRequestCount;

@end