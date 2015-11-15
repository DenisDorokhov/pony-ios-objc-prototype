//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTokenPairDaoImpl.h"
#import "PNYMacros.h"

@implementation PNYTokenPairDaoImpl

static NSString *const KEY_TOKEN_PAIR = @"PNYTokenDataDaoImpl.tokenPair";

static NSString *const KEY_ACCESS_TOKEN = @"accessToken";
static NSString *const KEY_ACCESS_TOKEN_EXPIRATION = @"accessTokenExpiration";
static NSString *const KEY_REFRESH_TOKEN = @"refreshToken";
static NSString *const KEY_REFRESH_TOKEN_EXPIRATION = @"refreshTokenExpiration";

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
    PNYTokenPair *tokenPair = [self fromDictionary:self.persistentDictionary.data[KEY_TOKEN_PAIR]];

    if (tokenPair != nil && ![[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULTS_KEY_HAS_TOKEN]) {

        PNYLogDebug(@"It seems like application was uninstalled. Returning no token.");

        return nil;
    }

    return tokenPair;
}

- (void)storeTokenPair:(PNYTokenPair *)aTokenPair
{
    PNYAssert(aTokenPair != nil);

    self.persistentDictionary.data[KEY_TOKEN_PAIR] = [self toDictionary:aTokenPair];

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

#pragma mark - Private

- (NSDictionary *)toDictionary:(PNYTokenPair *)aTokenPair
{
    return @{
            KEY_ACCESS_TOKEN : aTokenPair.accessToken,
            KEY_ACCESS_TOKEN_EXPIRATION : @([aTokenPair.accessTokenExpiration timeIntervalSince1970]),
            KEY_REFRESH_TOKEN : aTokenPair.refreshToken,
            KEY_REFRESH_TOKEN_EXPIRATION : @([aTokenPair.refreshTokenExpiration timeIntervalSince1970]),
    };
}

- (PNYTokenPair *)fromDictionary:(NSDictionary *)aDictionary
{
    PNYTokenPair *tokenPair = nil;

    if (aDictionary != nil) {

        tokenPair = [PNYTokenPair new];

        tokenPair.accessToken = aDictionary[KEY_ACCESS_TOKEN];
        tokenPair.accessTokenExpiration = [NSDate dateWithTimeIntervalSince1970:[aDictionary[KEY_ACCESS_TOKEN_EXPIRATION] doubleValue]];

        tokenPair.refreshToken = aDictionary[KEY_REFRESH_TOKEN];
        tokenPair.refreshTokenExpiration = [NSDate dateWithTimeIntervalSince1970:[aDictionary[KEY_REFRESH_TOKEN_EXPIRATION] doubleValue]];
    }

    return tokenPair;
}

@end