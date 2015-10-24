//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYObjectUtils.h"

@implementation PNYObjectUtils

+ (NSComparisonResult)compare:(id)aObject1 with:(id)aObject2
{
    if (aObject1 == aObject2) {
        return NSOrderedSame;
    } else if (aObject1 == nil) {
        return NSOrderedAscending;
    } else if (aObject2 == nil) {
        return NSOrderedDescending;
    }

    return [aObject1 compare:aObject2];
}

@end