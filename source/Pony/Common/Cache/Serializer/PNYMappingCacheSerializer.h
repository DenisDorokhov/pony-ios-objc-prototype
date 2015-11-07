//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCacheSerializer.h"

@interface PNYMappingCacheSerializer : NSObject <PNYCacheSerializer>

@property (nonatomic, readonly) Class valueClass;

+ (instancetype)mappingCacheSerializerWithValueClass:(Class)aValueClass;
- (instancetype)initWithValueClass:(Class)aValueClass;

+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;

@end