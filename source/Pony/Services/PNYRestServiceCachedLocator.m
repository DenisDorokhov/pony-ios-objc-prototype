//
// Created by Denis Dorokhov on 29/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <Typhoon/TyphoonAssembly.h>
#import "PNYRestServiceCachedLocator.h"

@implementation PNYRestServiceCachedLocator

+ (instancetype)sharedInstance
{
    static id INSTANCE = nil;
    if (INSTANCE == nil) {
        INSTANCE = [[self alloc] init];
    }
    return INSTANCE;
}

#pragma mark - Public

- (id <PNYRestServiceCached>)restServiceCached
{
    return [[TyphoonAssembly defaultAssembly] componentForType:@protocol(PNYRestServiceCached)];
}

@end