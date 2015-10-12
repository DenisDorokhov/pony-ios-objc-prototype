//
// Created by Denis Dorokhov on 12/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYConfigFactory.h"

@interface PNYConfigFactoryImpl : NSObject <PNYConfigFactory>

@property (nonatomic, strong) NSArray *dictionaries;

- (instancetype)initWithDictionaries:(NSArray *)aDictionaries;

@end