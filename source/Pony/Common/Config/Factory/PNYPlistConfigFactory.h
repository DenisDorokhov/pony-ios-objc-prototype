//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYConfig.h"

@interface PNYPlistConfigFactory : NSObject

- (id <PNYConfig>)configWithPlistPaths:(NSArray *)aPlistPaths;

@end