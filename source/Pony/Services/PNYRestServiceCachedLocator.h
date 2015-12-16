//
// Created by Denis Dorokhov on 29/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceCached.h"

@interface PNYRestServiceCachedLocator : NSObject

@property (nonatomic, readonly) id <PNYRestServiceCached> restServiceCached;

+ (instancetype)sharedInstance;

@end