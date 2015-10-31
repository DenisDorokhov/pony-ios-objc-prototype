//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCacheSerializerString.h"
#import "PNYErrorUtils.h"

@implementation PNYCacheSerializerString

#pragma mark - <PNYCacheSerializer>

- (NSData *)serializeValue:(id)aValue
{
    if (![aValue isKindOfClass:[NSString class]]) {
        @throw [PNYErrorUtils exceptionForObject:self message:@"NSString value expected."];
    }

    return [aValue dataUsingEncoding:NSUTF8StringEncoding];
}

- (id)unserializeValue:(NSData *)aValue
{
    return [[NSString alloc] initWithData:aValue encoding:NSUTF8StringEncoding];
}

@end