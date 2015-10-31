//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@protocol PNYRestRequest <NSObject>

@property (nonatomic, readonly) BOOL cancelled;

- (void)cancel;

@end