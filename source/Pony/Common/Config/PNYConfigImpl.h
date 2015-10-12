//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYConfig.h"

@interface PNYConfigImpl : NSObject <PNYConfig>

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary;

@end