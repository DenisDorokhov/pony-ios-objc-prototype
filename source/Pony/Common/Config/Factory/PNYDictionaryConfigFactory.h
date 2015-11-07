//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYConfig.h"

@interface PNYDictionaryConfigFactory : NSObject

- (id <PNYConfig>)configWithDictionaries:(NSArray *)aDictionaries;

@end