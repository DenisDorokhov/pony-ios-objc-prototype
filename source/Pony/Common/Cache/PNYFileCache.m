//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <NSHash/NSString+NSHash.h>
#import "PNYFileCache.h"
#import "PNYFileUtils.h"
#import "PNYMacros.h"

@implementation PNYFileCache

- (instancetype)initWithFolderPath:(NSString *)aFolderPath serializer:(id <PNYCacheSerializer>)aSerializer
{
    self = [super init];
    if (self != nil) {

        _folderPath = [aFolderPath copy];
        _serializer = aSerializer;

        self.excludeFromBackup = YES;

        [PNYFileUtils createDirectory:self.folderPath];
    }
    return self;
}

- (instancetype)initWithFolderPathInDocuments:(NSString *)aFolderPath serializer:(id <PNYCacheSerializer>)aSerializer
{
    return [self initWithFolderPath:[PNYFileUtils filePathInDocuments:aFolderPath] serializer:aSerializer];
}

- (instancetype)initWithFolderPathInCache:(NSString *)aFolderPath serializer:(id <PNYCacheSerializer>)aSerializer
{
    return [self initWithFolderPath:[PNYFileUtils filePathInCache:aFolderPath] serializer:aSerializer];
}

#pragma mark - <PNYCache>

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

    NSString *filePath = [self buildFilePathNameForKey:aKey];

    [valueData writeToFile:filePath atomically:YES];

    [[NSURL fileURLWithPath:filePath] setResourceValue:@(self.excludeFromBackup)
                                                forKey:NSURLIsExcludedFromBackupKey error:nil];

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

#pragma mark - Override

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"folderPath=%@", self.folderPath];
    [description appendString:@">"];
    return description;
}

#pragma mark - Private

- (NSString *)buildFilePathNameForKey:(NSString *)aKey
{
    return [self.folderPath stringByAppendingPathComponent:[aKey MD5]];
}

@end