//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface PNYCacheSerializerMapping : NSObject

@property (nonatomic, readonly) Class valueClass;

- (instancetype)initWithValueClass:(Class)aValueClass;

- (instancetype)init __unavailable;

@end