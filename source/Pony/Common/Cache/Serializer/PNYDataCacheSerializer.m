//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYDataCacheSerializer.h"
#import "PNYErrorUtils.h"

@implementation PNYDataCacheSerializer

#pragma mark - <PNYCacheSerializer>

- (NSData *)serializeValue:(id)aValue
{
    if (![aValue isKindOfClass:[NSData class]]) {
        @throw [PNYErrorUtils exceptionForObject:self message:@"NSData value expected."];
    }

    return aValue;
}

- (id)unserializeValue:(NSData *)aValue
{
    return aValue;
}

@end