//
// Created by Denis Dorokhov on 25/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface PNYDtoUtils : NSObject

+ (NSDate *)timestampToDate:(NSNumber *)aTimestamp;
+ (NSNumber *)dateToTimestamp:(NSDate *)aDate;

@end