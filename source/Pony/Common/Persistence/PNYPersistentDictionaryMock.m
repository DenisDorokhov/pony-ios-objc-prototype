//
// Created by Denis Dorokhov on 06/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYPersistentDictionaryMock.h"

@implementation PNYPersistentDictionaryMock
{
@private
    NSMutableDictionary *_data;
}

#pragma mark - <PNYPersistentDictionary>

- (NSMutableDictionary *)data
{
    if (_data == nil) {
        _data = [NSMutableDictionary dictionary];
    }

    return _data;
}

- (void)save
{
    // Do nothing.
}

@end