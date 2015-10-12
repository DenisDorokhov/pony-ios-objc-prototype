//
// Created by Denis Dorokhov on 12/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYConfigFactoryImpl.h"
#import "PNYConfigImpl.h"

@implementation PNYConfigFactoryImpl

- (instancetype)initWithDictionaries:(NSArray *)aDictionaries
{
    self = [super init];

    if (self != nil) {
        _dictionaries = aDictionaries;
    }

    return self;
}

- (instancetype)init
{
    return [self initWithDictionaries:[NSArray array]];
}

#pragma mark - <PNYConfigFactory>

- (id <PNYConfig>)createConfig
{
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];

    for (NSDictionary *dictionary in _dictionaries) {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *aKey, id aValue, BOOL *aStop) {

            if (resultDictionary[aKey] != nil) {
                DDLogWarn(@"Overriding value for key [%@]", aKey);
            }

            resultDictionary[aKey] = aValue;
        }];
    }

    return [[PNYConfigImpl alloc] initWithDictionary:resultDictionary];
}

@end