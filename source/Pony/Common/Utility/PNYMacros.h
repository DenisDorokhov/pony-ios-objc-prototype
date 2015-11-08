//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#define PNYAssert(expression) NSAssert(expression, @"" #expression)

#define PNYLogVerbose(format, ...) DDLogVerbose(format, ##__VA_ARGS__)
#define PNYLogDebug(format, ...) DDLogDebug(format, ##__VA_ARGS__)
#define PNYLogInfo(format, ...) DDLogInfo(format, ##__VA_ARGS__)
#define PNYLogWarn(format, ...) DDLogWarn(format, ##__VA_ARGS__)
#define PNYLogError(format, ...) DDLogError(format, ##__VA_ARGS__)

#define PNYLocalized(key, ...) [NSString stringWithFormat:NSLocalizedString(key, nil), ##__VA_ARGS__]