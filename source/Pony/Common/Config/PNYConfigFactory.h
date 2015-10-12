//
// Created by Denis Dorokhov on 12/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYConfig.h"

@protocol PNYConfigFactory <NSObject>

- (id <PNYConfig>)createConfig;

@end