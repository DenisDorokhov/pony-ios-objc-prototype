//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYPlistConfigFactory.h"
#import "PNYDictionaryConfigFactory.h"

@implementation PNYPlistConfigFactory
{
@private
    PNYDictionaryConfigFactory *dictionaryConfigFactory;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {
        dictionaryConfigFactory = [PNYDictionaryConfigFactory new];
    }
    return self;
}

#pragma mark - Public

- (id <PNYConfig>)configWithPlistPaths:(NSArray *)aPlistPaths
{
    NSMutableArray *dictionaries = [NSMutableArray array];
    for (NSString *path in aPlistPaths) {
        [dictionaries addObject:[NSDictionary dictionaryWithContentsOfFile:path]];
    }
    return [dictionaryConfigFactory configWithDictionaries:dictionaries];
}

@end