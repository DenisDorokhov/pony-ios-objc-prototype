//
// Created by Denis Dorokhov on 13/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface PNYFileUtils : NSObject

+ (NSString *)documentsPath;
+ (NSString *)cachePath;

+ (NSString *)sessionTemporaryPath;
+ (NSString *)generateTemporaryFilePath;
+ (NSString *)createTemporaryDirectory;
+ (NSString *)createTemporaryFile;

+ (NSString *)filePathInDocuments:(NSString *)aFilePath;
+ (NSString *)filePathInCache:(NSString *)aFilePath;
+ (NSString *)filePathInBundleOfClass:(Class)aClass withName:(NSString *)aFileName;

+ (NSString *)createNotExistingDirectory:(NSString *)aPath;

+ (NSString *)randomFilePathInPath:(NSString *)aPath;

@end