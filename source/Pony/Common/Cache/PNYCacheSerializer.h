//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@protocol PNYCacheSerializer <NSObject>

- (NSData *)serializeValue:(id)aValue;
- (id)unserializeValue:(NSData *)aValue;

@end