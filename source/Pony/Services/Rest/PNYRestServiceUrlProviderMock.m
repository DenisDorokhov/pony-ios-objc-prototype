//
// Created by Denis Dorokhov on 25/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceUrlProviderMock.h"

@implementation PNYRestServiceUrlProviderMock

+ (instancetype)serviceUrlProviderWithUrlToReturn:(NSString *)aUrlToReturn
{
    return [[self alloc] initWithUrlToReturn:aUrlToReturn];
}

- (instancetype)initWithUrlToReturn:(NSString *)aUrlToReturn
{
    self = [self init];
    if (self != nil) {
        self.urlToReturn = aUrlToReturn;
    }
    return self;
}

#pragma mark - <PNYRestServiceUrlProvider>

- (NSURL *)serverUrl
{
    return [NSURL URLWithString:self.urlToReturn];
}

@end