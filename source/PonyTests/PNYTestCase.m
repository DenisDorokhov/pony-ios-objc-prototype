//
// Created by Denis Dorokhov on 12/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYLogFormatter.h"

@implementation PNYTestCase

+ (void)setUp
{
    [super setUp];

    DDTTYLogger *logger = [DDTTYLogger sharedInstance];
    logger.logFormatter = [[PNYLogFormatter alloc] init];
    [DDLog addLogger:logger];
}

@end