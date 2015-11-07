//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYPersistentDictionary.h"
#import "PNYTokenPairDao.h"

@interface PNYTokenPairDaoImpl : NSObject <PNYTokenPairDao>

@property (nonatomic, readonly) id <PNYPersistentDictionary> persistentDictionary;

- (instancetype)initWithPersistentDictionary:(id <PNYPersistentDictionary>)aPersistentDictionary;

+ (instancetype)new __unavailable;
- (instancetype)init __unavailable;

@end