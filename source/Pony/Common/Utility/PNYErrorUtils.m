//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYErrorUtils.h"

@implementation PNYErrorUtils

+ (NSError *) errorForObject:(NSObject *)aObject message:(NSString *)aMessage
{
    return [self errorForObject:aObject code:0 message:aMessage];
}

+ (NSError *) errorForObject:(NSObject *)aObject code:(NSInteger)aCode message:(NSString *)aMessage
{
    return [self errorForClass:[aObject class] code:aCode message:aMessage];
}

+ (NSError *) errorForClass:(Class)aClass message:(NSString *)aMessage
{
    return [self errorForClass:aClass code:0 message:aMessage];
}

+ (NSError *) errorForClass:(Class)aClass code:(NSInteger)aCode message:(NSString *)aMessage
{
    return [self errorWithDomain:NSStringFromClass(aClass) code:aCode message:aMessage];
}

+ (NSError *) errorWithDomain:(NSString *)aDomain code:(NSInteger)aCode message:(NSString *)aMessage
{
    NSDictionary *userInfo = @{ NSLocalizedDescriptionKey : aMessage };

    return [NSError errorWithDomain:aDomain code:aCode userInfo:userInfo];
}

+ (NSException *)exceptionForObject:(NSObject *)aObject message:(NSString *)aMessage
{
    return [self exceptionForClass:[aObject class] message:aMessage];
}

+ (NSException *)exceptionForClass:(Class)aClass message:(NSString *)aMessage
{
    return [NSException exceptionWithName:NSStringFromClass(aClass) reason:aMessage userInfo:nil];
}

@end