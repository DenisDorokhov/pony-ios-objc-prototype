//
// Created by Denis Dorokhov on 12/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYLogFormatter.h"

@implementation PNYLogFormatter
{
@private
    NSDateFormatter *dateFormatter;
}

- (instancetype)init
{
    self = [super init];

    if (self != nil) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
    }

    return self;
}

#pragma mark - DDLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)aLogMessage
{
    NSMutableString *buffer = [NSMutableString stringWithString:[dateFormatter stringFromDate:aLogMessage.timestamp]];

    [buffer appendFormat:@" %@[%d:%@]", [[NSProcessInfo processInfo] processName], (int)getpid(), aLogMessage.threadID];
    [buffer appendFormat:@" %@",[self flagToString:aLogMessage.flag]];
    [buffer appendFormat:@" %@:%lu %@", [aLogMessage.file lastPathComponent], (unsigned long)aLogMessage.line, aLogMessage.message];

    return buffer;
}

#pragma mark - Private

- (NSString *)flagToString:(DDLogFlag)aLogFlag
{
    switch (aLogFlag) {
        case DDLogFlagVerbose:
            return @"TRACE";
        case DDLogFlagDebug:
            return @"DEBUG";
        case DDLogFlagInfo:
            return @"INFO";
        case DDLogFlagWarning:
            return @"WARN";
        case DDLogFlagError:
            return @"ERROR";
    }
    return nil;
}

@end