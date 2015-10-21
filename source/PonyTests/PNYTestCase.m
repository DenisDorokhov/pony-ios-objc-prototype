//
// Created by Denis Dorokhov on 12/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYLogFormatter.h"
#import "PNYFileUtils.h"

@implementation PNYTestCase

+ (void)setUp
{
    [super setUp];

    // Tests share memory, the following code avoids adding logger two times.
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        DDTTYLogger *logger = [DDTTYLogger sharedInstance];
        logger.logFormatter = [[PNYLogFormatter alloc] init];
        [DDLog addLogger:logger];
    });
}

- (void)setUp
{
    [super setUp];

    self.continueAfterFailure = NO;

    [self cleanFiles];
    [self cleanUserDefaults];
    [self cleanKeychain];
}

- (void)tearDown
{
    [self cleanFiles];
    [self cleanUserDefaults];
    [self cleanKeychain];

    [super tearDown];
}

#pragma mark - Public

- (void)cleanFiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    for (NSString *item in [fileManager contentsOfDirectoryAtPath:[PNYFileUtils documentsPath] error:nil]) {
        [fileManager removeItemAtPath:[[PNYFileUtils documentsPath] stringByAppendingPathComponent:item] error:nil];
    }
    for (NSString *item in [fileManager contentsOfDirectoryAtPath:[PNYFileUtils cachePath] error:nil]) {
        [fileManager removeItemAtPath:[[PNYFileUtils cachePath] stringByAppendingPathComponent:item] error:nil];
    }
    for (NSString *item in [fileManager contentsOfDirectoryAtPath:[PNYFileUtils sessionTemporaryPath] error:nil]) {
        [fileManager removeItemAtPath:[[PNYFileUtils sessionTemporaryPath] stringByAppendingPathComponent:item] error:nil];
    }
}

- (void)cleanUserDefaults
{
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)cleanKeychain
{
    [self deleteAllKeysForSecurityClass:kSecClassGenericPassword];
    [self deleteAllKeysForSecurityClass:kSecClassInternetPassword];
    [self deleteAllKeysForSecurityClass:kSecClassCertificate];
    [self deleteAllKeysForSecurityClass:kSecClassKey];
    [self deleteAllKeysForSecurityClass:kSecClassIdentity];
}

#pragma mark - Private

-(void)deleteAllKeysForSecurityClass:(CFTypeRef)aSecurityClass
{
    SecItemDelete((__bridge CFDictionaryRef)@{(__bridge id)kSecClass : (__bridge id)aSecurityClass});
}

@end