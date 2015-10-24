//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYUrlUtils.h"

@implementation PNYUrlUtils

+ (NSString *)urlEncode:(NSString *)aString
{
    return [self urlEncode:aString encoding:kCFStringEncodingUTF8];
}

+ (NSString *)urlEncode:(NSString *)aString encoding:(CFStringEncoding)aEncoding
{
    NSString* encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
            (__bridge CFStringRef)aString,
            NULL,
            (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
            aEncoding));

    return encodedString;
}

+ (NSString *)urlDecode:(NSString *)aString
{
    return [self urlDecode:aString encoding:NSUTF8StringEncoding];
}

+ (NSString *)urlDecode:(NSString *)aString encoding:(NSStringEncoding)aEncoding
{
    return [aString stringByReplacingPercentEscapesUsingEncoding:aEncoding];
}

+ (NSString *)urlEncodeParams:(NSDictionary *)aDictionary
{
    return [self urlEncodeParams:aDictionary encoding:kCFStringEncodingUTF8];
}

+ (NSString *)urlEncodeParams:(NSDictionary *)aDictionary encoding:(CFStringEncoding)aEncoding
{
    NSMutableString *encodedParams = [NSMutableString string];

    for (NSString *name in aDictionary) {

        NSString *value = aDictionary[name];

        if ([encodedParams length] > 0) {
            [encodedParams appendString:@"&"];
        }

        [encodedParams appendFormat:@"%@=%@", [self urlEncode:name encoding:aEncoding], [self urlEncode:value encoding:aEncoding]];
    }

    return encodedParams;
}

+ (NSDictionary *)urlDecodeParams:(NSString *)aString
{
    return [self urlDecodeParams:aString encoding:NSUTF8StringEncoding];
}

+ (NSDictionary *)urlDecodeParams:(NSString *)aString encoding:(NSStringEncoding)aEncoding
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    for (NSString *pair in [aString componentsSeparatedByString:@"&"]) {

        NSArray *parts = [pair componentsSeparatedByString:@"="];

        if ([parts count] == 2) {
            dictionary[[self urlDecode:parts[0] encoding:aEncoding]] = [self urlDecode:parts[1] encoding:aEncoding];
        }
    }

    return dictionary;
}

@end