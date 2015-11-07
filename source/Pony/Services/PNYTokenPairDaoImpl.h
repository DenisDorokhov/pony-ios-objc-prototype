//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYPersistentDictionary.h"
#import "PNYTokenPairDao.h"

@interface PNYTokenPairDaoImpl : NSObject <PNYTokenPairDao>

@property (nonatomic, strong) id <PNYPersistentDictionary> persistentDictionary; // TODO: refactor to initWithPersistentDictionary

@end