//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface PNYErrorUtils : NSObject

+ (NSError *)errorForObject:(NSObject *)aObject message:(NSString *)aMessage;
+ (NSError *)errorForObject:(NSObject *)aObject code:(NSInteger)aCode message:(NSString *)aMessage;

+ (NSError *)errorForClass:(Class)aClass message:(NSString *)aMessage;
+ (NSError *)errorForClass:(Class)aClass code:(NSInteger)aCode message:(NSString *)aMessage;

+ (NSError *)errorWithDomain:(NSString *)aDomain code:(NSInteger)aCode message:(NSString *)aMessage;

+ (NSException *)exceptionForObject:(NSObject *)aObject message:(NSString *)aMessage;
+ (NSException *)exceptionForClass:(Class)aClass message:(NSString *)aMessage;

@end