//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface PNYUrlUtils : NSObject

+ (NSString *)urlEncode:(NSString *)aString;
+ (NSString *)urlEncode:(NSString *)aString encoding:(CFStringEncoding)aEncoding;

+ (NSString *)urlDecode:(NSString *)aString;
+ (NSString *)urlDecode:(NSString *)aString encoding:(NSStringEncoding)aEncoding;

+ (NSString *)urlEncodeParams:(NSDictionary *)aDictionary;
+ (NSString *)urlEncodeParams:(NSDictionary *)aDictionary encoding:(CFStringEncoding)aEncoding;

+ (NSDictionary *)urlDecodeParams:(NSString *)aString;
+ (NSDictionary *)urlDecodeParams:(NSString *)aString encoding:(NSStringEncoding)aEncoding;

@end