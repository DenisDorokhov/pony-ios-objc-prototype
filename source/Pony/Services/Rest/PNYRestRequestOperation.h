//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestRequest.h"

@interface PNYRestRequestOperation : NSObject<PNYRestRequest>

@property (nonatomic, readonly) NSOperation *operation;

+ (instancetype)requestWithOperation:(NSOperation *)aOperation;

- (instancetype)initWithOperation:(NSOperation *)aOperation;

- (instancetype)init __unavailable;

@end