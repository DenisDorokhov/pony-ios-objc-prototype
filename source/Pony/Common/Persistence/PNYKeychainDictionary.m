//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYKeychainDictionary.h"

@implementation PNYKeychainDictionary

@synthesize data = _data;

- (instancetype)initWithName:(NSString *)aName
{
    self = [super init];

    if (self != nil) {

        _name = [aName copy];

        [self setup];
    }

    return self;
}

- (instancetype)init
{
    return [self initWithName:@"PNYKeychainDictionary"];
}

#pragma mark - <PNYPersistentDictionary>

- (void)save
{
    NSMutableDictionary *keychainQuery = [self keychainQuery];

    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);

    keychainQuery[(__bridge id)kSecValueData] = [NSKeyedArchiver archivedDataWithRootObject:_data];

    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

#pragma mark - Private

- (void)setup
{
    NSMutableDictionary *keychainQuery = [self keychainQuery];

    keychainQuery[(__bridge id)kSecReturnData] = (__bridge id)kCFBooleanTrue;
    keychainQuery[(__bridge id)kSecMatchLimit] = (__bridge id)kSecMatchLimitOne;

    CFDataRef keyData = NULL;

    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        _data = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
    }

    if (keyData) {
        CFRelease(keyData);
    }

    if (_data == nil) {
        _data = [NSMutableDictionary new];
    }
}

- (NSMutableDictionary *)keychainQuery
{
    return [@{
            (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
            (__bridge id)kSecAttrService : _name,
            (__bridge id)kSecAttrAccount : _name,
            (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAfterFirstUnlock
    } mutableCopy];
}

@end