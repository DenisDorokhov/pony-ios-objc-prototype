//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYImageCacheSerializer.h"
#import "PNYErrorUtils.h"

@implementation PNYImageCacheSerializer

#pragma mark - <PNYCacheSerializer>

- (NSData *)serializeValue:(id)aValue
{
    if (![aValue isKindOfClass:[UIImage class]]) {
        @throw [PNYErrorUtils exceptionForObject:self message:@"UIImage value expected."];
    }

    return UIImagePNGRepresentation(aValue);
}

- (id)unserializeValue:(NSData *)aValue
{
    return [UIImage imageWithData:aValue];
}

@end