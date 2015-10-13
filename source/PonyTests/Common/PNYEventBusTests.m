//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYEventBus.h"

@interface PNYEventBusTests : PNYTestCase

@end

@implementation PNYEventBusTests
{
@private
    NSUInteger countCallbackWithArgument;
    NSUInteger countCallbackWithTwoArguments;
    NSUInteger countCallbackWithoutArguments;
    NSUInteger countCallbackWithCancellation;
}

- (void)setUp
{
    [super setUp];

    [self reset];
}

- (void)testEventFiring
{
    PNYEventBus *eventBus = [PNYEventBus new];

    [eventBus addListener:@"someType" object:self selector:@selector(callback:)];

    [eventBus addListener:@"someType" object:self selector:@selector(callback:argument:)];

    [eventBus addListener:@"someType" object:self selector:@selector(callback)];
    [eventBus addListener:@"someType" object:self selector:@selector(callback)];

    // Test callback firing.

    [self reset];

    [eventBus fireEvent:[PNYEvent eventWithType:@"someType"]];

    XCTAssertEqual(countCallbackWithArgument, 1);
    XCTAssertEqual(countCallbackWithTwoArguments, 1);
    XCTAssertEqual(countCallbackWithoutArguments, 1);
    XCTAssertEqual(countCallbackWithCancellation, 0);

    // Test callback not firing.

    [self reset];

    [eventBus fireEvent:[PNYEvent eventWithType:@"otherType"]];

    XCTAssertEqual(countCallbackWithArgument, 0);
    XCTAssertEqual(countCallbackWithTwoArguments, 0);
    XCTAssertEqual(countCallbackWithoutArguments, 0);
    XCTAssertEqual(countCallbackWithCancellation, 0);

    [self reset];

    // Test listener removal.

    [eventBus removeListener:@"someType" object:self selector:@selector(callback)];

    [eventBus fireEvent:[PNYEvent eventWithType:@"someType"]];

    XCTAssertEqual(countCallbackWithArgument, 1);
    XCTAssertEqual(countCallbackWithTwoArguments, 1);
    XCTAssertEqual(countCallbackWithoutArguments, 0);
    XCTAssertEqual(countCallbackWithCancellation, 0);

    // Test removal of all listeners.

    [self reset];

    [eventBus removeListenersWithObject:self];

    [eventBus fireEvent:[PNYEvent eventWithType:@"someType"]];

    XCTAssertEqual(countCallbackWithArgument, 0);
    XCTAssertEqual(countCallbackWithTwoArguments, 0);
    XCTAssertEqual(countCallbackWithoutArguments, 0);
    XCTAssertEqual(countCallbackWithCancellation, 0);
}

- (void)testEventCancellation
{
    PNYEventBus *eventBus = [PNYEventBus new];

    [eventBus addListener:@"someType" object:self selector:@selector(callbackWithCancellation:)];
    [eventBus addListener:@"someType" object:self selector:@selector(callback)];

    [eventBus fireEvent:[PNYEvent eventWithType:@"someType"]];

    XCTAssertEqual(countCallbackWithArgument, 0);
    XCTAssertEqual(countCallbackWithTwoArguments, 0);
    XCTAssertEqual(countCallbackWithoutArguments, 0);
    XCTAssertEqual(countCallbackWithCancellation, 1);
}

#pragma mark - Events

- (void)callback:(PNYEvent *)aEvent
{
    XCTAssertNotNil(aEvent);
    XCTAssertEqual(aEvent.type, @"someType");

    countCallbackWithArgument++;
}

- (void)callback:(PNYEvent *)aEvent argument:(NSObject *)aSomeArgument
{
    XCTAssertNotNil(aEvent);
    XCTAssertEqual(aEvent.type, @"someType");
    XCTAssertNil(aSomeArgument);

    countCallbackWithTwoArguments++;
}

- (void)callback
{
    countCallbackWithoutArguments++;
}

- (void)callbackWithCancellation:(PNYEvent *)aEvent
{
    XCTAssertNotNil(aEvent);
    XCTAssertEqual(aEvent.type, @"someType");

    [aEvent cancel];

    countCallbackWithCancellation++;
}

#pragma mark - Private

- (void)reset
{
    countCallbackWithArgument = 0;
    countCallbackWithTwoArguments = 0;
    countCallbackWithoutArguments = 0;
    countCallbackWithCancellation = 0;
}

@end