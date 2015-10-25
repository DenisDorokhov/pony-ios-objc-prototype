//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <AFNetworking/AFURLResponseSerialization.h>

@interface PNYRestResponseSerializer : AFJSONResponseSerializer

@property (nonatomic, readonly) Class dataClass;

+ (instancetype)serializerWithDataClass:(Class)aDataClass;

- (instancetype)initWithDataClass:(Class)aDataClass;

+ (instancetype) __unavailable serializer;

- (instancetype) __unavailable init;

@end