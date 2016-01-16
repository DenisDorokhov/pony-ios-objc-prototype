//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKSerializer.h>
#import <EasyMapping/EKMapper.h>
#import "PNYTokenPairDaoImpl.h"
#import "PNYMacros.h"

@implementation PNYTokenPairDaoImpl

static NSString *const KEY_TOKEN_PAIR = @"PNYTokenDataDaoImpl.tokenPair";

/**
 * When NSUserDefaults value for this key does not exists, no token data will be fetched.
 * This behavior is implemented to avoid token fetching when the application was uninstalled.
 */
static NSString *const USER_DEFAULTS_KEY_HAS_TOKEN = @"PNYTokenPairDaoImpl.hasToken";

- (instancetype)initWithPersistentDictionary:(id <PNYPersistentDictionary>)aPersistentDictionary
{
    PNYAssert(aPersistentDictionary != nil);

    self = [super init];
    if (self != nil) {
        _persistentDictionary = aPersistentDictionary;
    }
    return self;
}

#pragma mark - <PNYSecurityStorage>

- (PNYTokenPair *)fetchTokenPair
{
    PNYTokenPair *tokenPair = nil;

    NSDictionary *tokenPairDictionary = self.persistentDictionary.data[KEY_TOKEN_PAIR];

    if (tokenPairDictionary != nil) {

        tokenPair = [EKMapper objectFromExternalRepresentation:tokenPairDictionary
                                                   withMapping:[PNYTokenPair objectMapping]];

        if (tokenPair != nil && ![[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULTS_KEY_HAS_TOKEN]) {

            PNYLogDebug(@"It seems like application was uninstalled. Removing the token.");

            [self removeTokenPair];

            tokenPair = nil;
        }
    }

    return tokenPair;
}

- (void)storeTokenPair:(PNYTokenPair *)aTokenPair
{
    PNYAssert(aTokenPair != nil);

    self.persistentDictionary.data[KEY_TOKEN_PAIR] = [EKSerializer serializeObject:aTokenPair
                                                                       withMapping:[PNYTokenPair objectMapping]];

    [self.persistentDictionary save];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_DEFAULTS_KEY_HAS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];

    PNYLogVerbose(@"Token pair stored.");
}

- (void)removeTokenPair
{
    [self.persistentDictionary.data removeObjectForKey:KEY_TOKEN_PAIR];

    [self.persistentDictionary save];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_DEFAULTS_KEY_HAS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];

    PNYLogVerbose(@"Token pair removed.");
}

@end