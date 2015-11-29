//
// Created by Denis Dorokhov on 29/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestService.h"

@interface PNYRestServiceLocator : NSObject

@property (nonatomic, readonly) id <PNYRestService> restService;

+ (instancetype)sharedInstance;

@end