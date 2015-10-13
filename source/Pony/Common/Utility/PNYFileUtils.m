//
// Created by Denis Dorokhov on 13/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYFileUtils.h"
#import "PNYRandomUtils.h"

@implementation PNYFileUtils

+ (NSString *)documentsPath
{
    static NSString *_documentsPath = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

        _documentsPath = [self createDirectoryIfNotExists:paths[0]];
    });

    return _documentsPath;
}

+ (NSString *)cachePath
{
    static NSString *_cachePath = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

        _cachePath = [self createDirectoryIfNotExists:paths[0]];
    });

    return _cachePath;
}

+ (NSString *)sessionTemporaryPath
{
    static NSString *_temporaryPath = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        _temporaryPath = [self randomFilePathInPath:NSTemporaryDirectory()];

        [self createDirectoryIfNotExists:_temporaryPath];
    });

    return _temporaryPath;
}

+ (NSString *)generateTemporaryFilePath
{
    NSString *tempPath = [self sessionTemporaryPath];

    [self createDirectoryIfNotExists:tempPath];

    return [self randomFilePathInPath:tempPath];
}

+ (NSString *)createTemporaryDirectory
{
    NSString *path = [self generateTemporaryFilePath];

    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:nil];

    return path;
}

+ (NSString *)createTemporaryFile
{
    NSString *path = [self generateTemporaryFilePath];

    [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];

    return path;
}

+ (NSString *)filePathInDocuments:(NSString *)aFilePath
{
    return [[self documentsPath] stringByAppendingPathComponent:aFilePath];
}

+ (NSString *)filePathInCache:(NSString *)aFilePath
{
    return [[self cachePath] stringByAppendingPathComponent:aFilePath];
}

+ (NSString *)filePathInBundleOfClass:(Class)aClass withName:(NSString *)aFileName
{
    return [[NSBundle bundleForClass:aClass] pathForResource:aFileName ofType:nil];
}

+ (NSString *)createDirectoryIfNotExists:(NSString *)aPath
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:aPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:aPath withIntermediateDirectories:YES
                                                   attributes:nil error:nil];
    }

    return aPath;
}

+ (NSString *)randomFilePathInPath:(NSString *)aPath
{
    NSString *result = nil;

    do {
        result = [aPath stringByAppendingPathComponent:[PNYRandomUtils uuid]];
    } while ([[NSFileManager defaultManager] fileExistsAtPath:result]);

    return result;
}

@end