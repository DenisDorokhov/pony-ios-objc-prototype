//
// Created by Denis Dorokhov on 29/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <Typhoon/TyphoonAssembly.h>
#import "PNYRestServiceLocator.h"
#import "PNYRestServiceCached.h"

@implementation PNYRestServiceLocator

static id INSTANCE = nil;

+ (instancetype)sharedInstance
{
    if (INSTANCE == nil) {
        INSTANCE = [[self alloc] init];
    }
    return INSTANCE;
}

#pragma mark - Public

- (id <PNYRestService>)restService
{
    return [[TyphoonAssembly defaultAssembly] componentForType:@protocol(PNYRestServiceCached)];
}

@end