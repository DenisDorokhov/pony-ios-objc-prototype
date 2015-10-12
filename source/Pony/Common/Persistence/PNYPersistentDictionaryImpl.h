//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYPersistentDictionary.h"

@interface PNYPersistentDictionaryImpl : NSObject <PNYPersistentDictionary>

@property (nonatomic, readonly) NSString *filePath;

@property (nonatomic) NSTimeInterval fileFlushInterval;

@property (nonatomic) BOOL excludeFromBackup;

- (instancetype)initWithFilePath:(NSString *)aFilePath;

@end