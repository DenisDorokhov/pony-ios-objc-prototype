//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <NSHash/NSString+NSHash.h>
#import "PNYCacheImpl.h"
#import "PNYFileUtils.h"
#import "PNYMacros.h"

@implementation PNYCacheImpl

- (instancetype)initWithFolderPath:(NSString *)aFolderPath serializer:(id <PNYCacheSerializer>)aSerializer
{
    self = [super init];
    if (self != nil) {

        _folderPath = [aFolderPath copy];
        _serializer = aSerializer;

        [PNYFileUtils createNotExistingDirectory:_folderPath];
    }
    return self;
}

#pragma mark - <PNYCache>

- (id)cachedValueForKey:(NSString *)aKey
{
    NSData *valueData = [NSData dataWithContentsOfFile:[self buildFilePathNameForKey:aKey]];

    if (valueData != nil) {

        PNYLogVerbose(@"Cache hit for key [%@] in folder [%@].", aKey, _folderPath);

        return [_serializer unserializeValue:valueData];
    }

    return nil;
}

- (void)cacheValue:(id)aValue forKey:(NSString *)aKey
{
    NSData *valueData = [_serializer serializeValue:aValue];

    [valueData writeToFile:[self buildFilePathNameForKey:aKey] atomically:YES];

    PNYLogVerbose(@"Cached value for key [%@] in folder [%@].", aKey, _folderPath);
}

- (void)removeCachedValueForKey:(NSString *)aKey
{
    [[NSFileManager defaultManager] removeItemAtPath:[self buildFilePathNameForKey:aKey]
                                               error:nil];

    PNYLogVerbose(@"Removed value for key [%@] in folder [%@].", aKey, _folderPath);
}

- (void)removeAllCachedValues
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:_folderPath error:nil];
    for (NSString *filePath in fileList) {
        [fileManager removeItemAtPath:[_folderPath stringByAppendingPathComponent:filePath] error:nil];
    }

    PNYLogDebug(@"Removed all values in folder [%@].", _folderPath);
}

#pragma mark - Private

- (NSString *)buildFilePathNameForKey:(NSString *)aKey
{
    return [_folderPath stringByAppendingPathComponent:[aKey MD5]];
}

@end