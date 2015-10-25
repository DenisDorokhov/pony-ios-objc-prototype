//
// Created by Denis Dorokhov on 12/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#define PNYTestExpectationCreate() [self expectationWithDescription:@(__PRETTY_FUNCTION__)]
#define PNYTestExpectationWait() [self waitForExpectationsWithTimeout:5 handler:nil];

@interface PNYTestCase : XCTestCase

- (void)cleanFiles;
- (void)cleanUserDefaults;
- (void)cleanKeychain;

@end