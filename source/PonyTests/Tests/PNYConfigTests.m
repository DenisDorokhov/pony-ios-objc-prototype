//
// Created by Denis Dorokhov on 13/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYConfigFactoryImpl.h"
#import "PNYTestCase.h"
#import "PNYConfigImpl.h"

@interface PNYConfigTests : PNYTestCase

@end

@implementation PNYConfigTests

- (void)testConfig
{
    PNYConfigImpl *config = [[PNYConfigImpl alloc] initWithDictionary:@{
            @"string1" : @"value",
            @"string2" : @123,
            @"number" : @1.23f,
            @"bool" : @YES,
            @"int" : @123,
            @"float" : @1.23f,
            @"double" : @1.23,
            @"point" : @{ @"x" : @1, @"y" : @2 },
            @"size" : @{ @"width" : @1, @"height" : @2 },
            @"rect" : @{ @"x" : @1, @"y" : @2, @"width" : @3, @"height" : @4 },
            @"insets" : @{ @"top" : @1, @"bottom" : @2, @"left" : @3, @"right" : @4 },
            @"color" : @{ @"red" : @10, @"green" : @20, @"blue" : @30, @"alpha" : @40 },
    }];

    XCTAssertEqualObjects([config stringValue:@"string1"], @"value");
    XCTAssertEqualObjects([config stringValue:@"string2"], @"123");

    XCTAssert([[config numberValue:@"number"] isKindOfClass:[NSNumber class]]);
    XCTAssertEqualWithAccuracy([[config numberValue:@"number"] floatValue], 1.23f, 0.001f);

    XCTAssertEqual([config boolValue:@"bool"], YES);
    XCTAssertEqual([config intValue:@"int"], 123);
    XCTAssertEqualWithAccuracy([config floatValue:@"float"], 1.23f, 0.001f);
    XCTAssertEqualWithAccuracy([config doubleValue:@"double"], 1.23, 0.001);

    CGPoint point = [config pointValue:@"point"];

    XCTAssertEqual(point.x, 1.0f);
    XCTAssertEqual(point.y, 2.0f);

    CGSize size = [config sizeValue:@"size"];

    XCTAssertEqual(size.width, 1.0f);
    XCTAssertEqual(size.height, 2.0f);

    CGRect rect = [config rectValue:@"rect"];

    XCTAssertEqual(rect.origin.x, 1.0f);
    XCTAssertEqual(rect.origin.y, 2.0f);
    XCTAssertEqual(rect.size.width, 3.0f);
    XCTAssertEqual(rect.size.height, 4.0f);

    UIEdgeInsets insets = [config insetsValue:@"insets"];

    XCTAssertEqual(insets.top, 1.0f);
    XCTAssertEqual(insets.bottom, 2.0f);
    XCTAssertEqual(insets.left, 3.0f);
    XCTAssertEqual(insets.right, 4.0f);

    UIColor *color = [config colorValue:@"color"];

    CGFloat red, green, blue, alpha;

    [color getRed:&red green:&green blue:&blue alpha:&alpha];

    XCTAssertEqualWithAccuracy(red * 255.0f, 10, 0.001f);
    XCTAssertEqualWithAccuracy(green * 255.0f, 20, 0.001f);
    XCTAssertEqualWithAccuracy(blue * 255.0f, 30, 0.001f);
    XCTAssertEqualWithAccuracy(alpha * 255.0f, 40, 0.001f);

    XCTAssertNil([config stringValue:@"point"]);
    XCTAssertNil([config numberValue:@"string1"]);

    XCTAssertEqual([config boolValue:@"string1"], NO);
    XCTAssertEqual([config intValue:@"string1"], 0);
    XCTAssertEqual([config floatValue:@"string1"], 0.0f);
    XCTAssertEqual([config doubleValue:@"string1"], 0.0);

    XCTAssert(CGPointEqualToPoint([config pointValue:@"string1"], CGPointZero));
    XCTAssert(CGSizeEqualToSize([config sizeValue:@"string1"], CGSizeZero));
    XCTAssert(CGRectEqualToRect([config rectValue:@"string1"], CGRectZero));
    XCTAssert(UIEdgeInsetsEqualToEdgeInsets([config insetsValue:@"string1"], UIEdgeInsetsZero));

    XCTAssertNil([config colorValue:@"string1"]);
}

- (void)testConfigFactory
{
    NSArray *dictionaries = @[
            @{
                    @"key1" : @"value1",
                    @"key2" : @"value2",
            },
            @{
                    @"key1" : @"value3",
            }
    ];

    PNYConfigFactoryImpl *factory = [[PNYConfigFactoryImpl alloc] initWithDictionaries:dictionaries];

    id <PNYConfig> config = [factory createConfig];

    XCTAssertEqualObjects([config stringValue:@"key1"], @"value3");
    XCTAssertEqualObjects([config stringValue:@"key2"], @"value2");
}

@end