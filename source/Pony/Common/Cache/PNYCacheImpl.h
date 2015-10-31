//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCache.h"
#import "PNYCacheSerializer.h"

@interface PNYCacheImpl : NSObject <PNYCache>

@property (nonatomic, readonly) NSString *folderPath;
@property (nonatomic, readonly) id <PNYCacheSerializer> serializer;

- (instancetype)initWithFolderPath:(NSString *)aFolderPath serializer:(id <PNYCacheSerializer>)aSerializer;

- (instancetype)init __unavailable;

@end