//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestRequestOperation.h"

@implementation PNYRestRequestOperation

+ (instancetype)requestWithOperation:(NSOperation *)aOperation
{
    return [[self alloc] initWithOperation:aOperation];
}

- (instancetype)initWithOperation:(NSOperation *)aOperation
{
    PNYAssert(aOperation != nil);

    self = [super init];
    if (self != nil) {
        _operation = aOperation;
    }
    return self;
}

#pragma mark - <PNYRestRequest>

- (BOOL)cancelled
{
    return self.operation.cancelled;
}

- (void)cancel
{
    [self.operation cancel];
}

@end