//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <NSHash/NSString+NSHash.h>
#import "PNYCacheImpl.h"
#import "PNYFileUtils.h"

@implementation PNYCacheImpl
{
@private
    NSString *_name;
}

- (instancetype)initWithFolderPath:(NSString *)aFolderPath serializer:(id <PNYCacheSerializer>)aSerializer
{
    return [self initWithFolderPath:aFolderPath serializer:aSerializer name:nil];
}

- (instancetype)initWithFolderPath:(NSString *)aFolderPath serializer:(id <PNYCacheSerializer>)aSerializer name:(NSString *)aName
{
    self = [super init];
    if (self != nil) {

        _folderPath = [aFolderPath copy];
        _serializer = aSerializer;
        _name = aName;

        [PNYFileUtils createNotExistingDirectory:self.folderPath];
    }
    return self;
}

#pragma mark - <PNYCache>

- (NSString *)name
{
    return _name;
}

- (BOOL)cachedValueExistsForKey:(NSString *)aKey
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self buildFilePathNameForKey:aKey]];
}

- (id)cachedValueForKey:(NSString *)aKey
{
    NSData *valueData = [NSData dataWithContentsOfFile:[self buildFilePathNameForKey:aKey]];

    if (valueData != nil) {

        PNYLogVerbose(@"Cache hit for key [%@] in folder [%@].", aKey, self.folderPath);

        return [self.serializer unserializeValue:valueData];
    }

    return nil;
}

- (void)cacheValue:(id)aValue forKey:(NSString *)aKey
{
    NSData *valueData = [self.serializer serializeValue:aValue];

    [valueData writeToFile:[self buildFilePathNameForKey:aKey] atomically:YES];

    PNYLogVerbose(@"Cached value for key [%@] in folder [%@].", aKey, self.folderPath);
}

- (void)removeCachedValueForKey:(NSString *)aKey
{
    [[NSFileManager defaultManager] removeItemAtPath:[self buildFilePathNameForKey:aKey]
                                               error:nil];

    PNYLogVerbose(@"Removed value for key [%@] in folder [%@].", aKey, self.folderPath);
}

- (void)removeAllCachedValues
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:self.folderPath error:nil];
    for (NSString *filePath in fileList) {
        [fileManager removeItemAtPath:[self.folderPath stringByAppendingPathComponent:filePath] error:nil];
    }

    PNYLogDebug(@"Removed all values in folder [%@].", self.folderPath);
}

#pragma mark - Private

- (NSString *)buildFilePathNameForKey:(NSString *)aKey
{
    return [self.folderPath stringByAppendingPathComponent:[aKey MD5]];
}

@end