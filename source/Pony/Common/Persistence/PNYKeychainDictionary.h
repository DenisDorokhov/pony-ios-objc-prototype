//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYPersistentDictionary.h"

@interface PNYKeychainDictionary : NSObject <PNYPersistentDictionary>

@property (nonatomic, readonly) NSString *name;

- (instancetype)initWithName:(NSString *)aName;

@end