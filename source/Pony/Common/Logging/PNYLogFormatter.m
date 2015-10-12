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

        dateFormatter = [[NSDateFormatter alloc] init];

        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    }

    return self;
}

#pragma mark - DDLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)aLogMessage
{
    NSMutableString *buffer = [NSMutableString string];

    [buffer appendString:[dateFormatter stringFromDate:aLogMessage.timestamp]];

    [buffer appendFormat:@" %@[%d:%@]", [[NSProcessInfo processInfo] processName], (int)getpid(), aLogMessage.threadID];
    [buffer appendFormat:@" %@:%lu %@", [aLogMessage.file lastPathComponent], (unsigned long)aLogMessage.line, aLogMessage.message];

    return buffer;
}

@end