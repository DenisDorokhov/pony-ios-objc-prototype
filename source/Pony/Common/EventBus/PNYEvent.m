//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYEvent.h"

@implementation PNYEvent

+ (instancetype)eventWithType:(NSString *)aType
{
    return [[self alloc] initWithType:aType];
}

+ (instancetype)eventWithType:(NSString *)aType userData:(id)aUserData
{
    return [[self alloc] initWithType:aType userData:aUserData];
}

- (instancetype)initWithType:(NSString *)aType
{
    return [self initWithType:aType userData:nil];
}

- (instancetype)initWithType:(NSString *)aType userData:(id)aUserData
{
    self = [self init];

    if (self != nil) {

        _type = [aType copy];

        self.userData = aUserData;
    }

    return self;
}

#pragma mark - Public

- (void)cancel
{
    _cancelled = YES;
}

@end