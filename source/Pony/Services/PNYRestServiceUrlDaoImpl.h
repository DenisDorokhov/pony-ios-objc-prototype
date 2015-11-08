//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceUrlDao.h"
#import "PNYUserSettings.h"

@interface PNYRestServiceUrlDaoImpl : NSObject <PNYRestServiceUrlDao>

@property (nonatomic, strong) id <PNYUserSettings> userSettings;

@end