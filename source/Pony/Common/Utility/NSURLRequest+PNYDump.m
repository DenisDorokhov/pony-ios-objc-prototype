//
// Created by Denis Dorokhov on 05/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "NSURLRequest+PNYDump.h"

@implementation NSURLRequest (PNYDump)

- (NSString *)dump
{
    NSMutableString *buffer = [NSMutableString string];

    [buffer appendFormat:@"<%@: %p> {\n", NSStringFromClass([self class]), (__bridge void *)self];

    [buffer appendFormat:@"\tURL: %@\n", self.URL];
    [buffer appendFormat:@"\tHTTPMethod: %@\n", self.HTTPMethod];

    [buffer appendString:@"\tallHTTPHeaderFields: {\n"];
    [self.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *aKey, NSString *aValue, BOOL *aStop) {
        [buffer appendFormat:@"\t\t%@: %@\n", aKey, aValue];
    }];
    [buffer appendString:@"\t}"];

    NSString *body = [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding];
    if (body.length > 0) {
        [buffer appendFormat:@"\n\tHTTPBody: %@", body];
    }

    [buffer appendString:@"\n}"];

    return buffer;
}


@end