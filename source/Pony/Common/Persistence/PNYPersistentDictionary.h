//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@protocol PNYPersistentDictionary <NSObject>

@property (nonatomic, readonly) NSMutableDictionary *data;

- (void)save;

@end