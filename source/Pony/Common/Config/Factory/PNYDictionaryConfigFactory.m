//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYDictionaryConfigFactory.h"
#import "PNYConfigImpl.h"
#import "PNYMacros.h"

@implementation PNYDictionaryConfigFactory

#pragma mark - Public

- (id <PNYConfig>)configWithDictionaries:(NSArray *)aDictionaries
{
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];

    for (NSDictionary *dictionary in aDictionaries) {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *aKey, id aValue, BOOL *aStop) {

            if (resultDictionary[aKey] != nil) {
                PNYLogWarn(@"Overriding value for key [%@].", aKey);
            }

            resultDictionary[aKey] = aValue;
        }];
    }

    return [[PNYConfigImpl alloc] initWithDictionary:resultDictionary];
}

@end