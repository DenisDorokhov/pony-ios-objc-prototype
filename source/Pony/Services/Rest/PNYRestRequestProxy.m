//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestRequestProxy.h"

@implementation PNYRestRequestProxy
{
@private
    BOOL _cancelled;
}

#pragma mark - <PNYRestRequest>

- (BOOL)cancelled
{
    return self.targetRequest != nil ? self.targetRequest.cancelled : _cancelled;
}

- (void)cancel
{
    if (self.targetRequest != nil) {
        [self.targetRequest cancel];
    } else {
        _cancelled = YES;
    }
}

@end