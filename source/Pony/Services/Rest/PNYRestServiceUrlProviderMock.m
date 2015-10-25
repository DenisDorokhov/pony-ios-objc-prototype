//
// Created by Denis Dorokhov on 25/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceUrlProviderMock.h"

@implementation PNYRestServiceUrlProviderMock

#pragma mark - <PNYRestServiceUrlProvider>

- (NSURL *)serverUrl
{
    return [NSURL URLWithString:self.url];
}

@end