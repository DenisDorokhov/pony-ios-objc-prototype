//
// Created by Denis Dorokhov on 25/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYDtoUtils.h"

@implementation PNYDtoUtils

+ (NSDate *)timestampToDate:(NSNumber *)aTimestamp
{
    return aTimestamp != (id)[NSNull null] ? [NSDate dateWithTimeIntervalSince1970:([aTimestamp doubleValue] / 1000.0)] : nil;
}

+ (NSNumber *)dateToTimestamp:(NSDate *)aDate
{
    return aDate != (id)[NSNull null] ? @([aDate timeIntervalSince1970] * 1000.0) : (id)[NSNull null];
}

@end