//
// Created by Denis Dorokhov on 13/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYConfigImpl.h"
#import "PNYDictionaryConfigFactory.h"

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

    assertThat([config stringValue:@"string1"], equalTo(@"value"));
    assertThat([config stringValue:@"string2"], equalTo(@"123"));

    assertThatBool([[config numberValue:@"number"] isKindOfClass:[NSNumber class]], isTrue());
    assertThatFloat([[config numberValue:@"number"] floatValue], closeTo(1.23, 0.001));

    assertThatBool([config boolValue:@"bool"], isTrue());
    assertThatInt([config intValue:@"int"], equalTo(@123));
    assertThatFloat([config floatValue:@"float"], closeTo(1.23, 0.001));
    assertThatDouble([config doubleValue:@"double"], closeTo(1.23, 0.001));

    CGPoint point = [config pointValue:@"point"];

    assertThatFloat(point.x, equalTo(@1));
    assertThatFloat(point.y, equalTo(@2));

    CGSize size = [config sizeValue:@"size"];

    assertThatFloat(size.width, equalTo(@1));
    assertThatFloat(size.height, equalTo(@2));

    CGRect rect = [config rectValue:@"rect"];

    assertThatFloat(rect.origin.x, equalTo(@1));
    assertThatFloat(rect.origin.y, equalTo(@2));
    assertThatFloat(rect.size.width, equalTo(@3));
    assertThatFloat(rect.size.height, equalTo(@4));

    UIEdgeInsets insets = [config insetsValue:@"insets"];

    assertThatFloat(insets.top, equalTo(@1));
    assertThatFloat(insets.bottom, equalTo(@2));
    assertThatFloat(insets.left, equalTo(@3));
    assertThatFloat(insets.right, equalTo(@4));

    UIColor *color = [config colorValue:@"color"];

    CGFloat red, green, blue, alpha;

    [color getRed:&red green:&green blue:&blue alpha:&alpha];

    assertThatFloat(red * 255.0f, closeTo(10, 0.001f));
    assertThatFloat(green * 255.0f, closeTo(20, 0.001f));
    assertThatFloat(blue * 255.0f, closeTo(30, 0.001f));
    assertThatFloat(alpha * 255.0f, closeTo(40, 0.001f));

    assertThat([config stringValue:@"point"], nilValue());
    assertThat([config numberValue:@"string1"], nilValue());

    assertThatBool([config boolValue:@"string1"], isFalse());
    assertThatInt([config intValue:@"string1"], equalTo(@0));
    assertThatFloat([config floatValue:@"string1"], equalTo(@0));
    assertThatDouble([config doubleValue:@"string1"], equalTo(@0));

    assertThatBool(CGPointEqualToPoint([config pointValue:@"string1"], CGPointZero), isTrue());
    assertThatBool(CGSizeEqualToSize([config sizeValue:@"string1"], CGSizeZero), isTrue());
    assertThatBool(CGRectEqualToRect([config rectValue:@"string1"], CGRectZero), isTrue());
    assertThatBool(UIEdgeInsetsEqualToEdgeInsets([config insetsValue:@"string1"], UIEdgeInsetsZero), isTrue());

    assertThat([config colorValue:@"string1"], nilValue());
}

- (void)testDictionaryConfigFactory
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

    PNYDictionaryConfigFactory *factory = [PNYDictionaryConfigFactory new];

    id <PNYConfig> config = [factory configWithDictionaries:dictionaries];

    assertThat([config stringValue:@"key1"], equalTo(@"value3"));
    assertThat([config stringValue:@"key2"], equalTo(@"value2"));
}

@end