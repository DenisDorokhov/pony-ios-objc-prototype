//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYConfigImpl.h"

@implementation PNYConfigImpl
{
@private
    NSDictionary *dictionary;
}

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];

    if (self != nil) {
        dictionary = aDictionary;
    }

    return self;
}

- (instancetype)init
{
    return [self initWithDictionary:[NSDictionary dictionary]];
}

#pragma mark - <PNYConfig>

- (NSString *)stringValue:(NSString *)aKey
{
    id value = [self fetchIfKeyExists:aKey];

    if (value != nil) {
        if ([value isKindOfClass:[NSString class]]) {
            return value;
        } else if ([value isKindOfClass:[NSNumber class]]) {
            return [value stringValue];
        } else {
            PNYLogWarn(@"[NSString] or [NSNumber] expected for key [%@].", aKey);
        }
    }

    return nil;
}

- (NSNumber *)numberValue:(NSString *)aKey
{
    id value = [self fetchIfKeyExists:aKey];

    if (value != nil) {
        if ([self validateValue:value type:[NSNumber class] configKey:aKey]) {
            return value;
        }
    }

    return nil;
}

- (BOOL)boolValue:(NSString *)aKey
{
    id value = [self fetchIfKeyExists:aKey];

    if (value != nil) {
        if ([self validateValue:value type:[NSNumber class] configKey:aKey]) {
            return [value boolValue];
        }
    }

    return NO;
}

- (int)intValue:(NSString *)aKey
{
    id value = [self fetchIfKeyExists:aKey];

    if (value != nil) {
        if ([self validateValue:value type:[NSNumber class] configKey:aKey]) {
            return [value intValue];
        }
    }

    return 0;
}

- (float)floatValue:(NSString *)aKey
{
    id value = [self fetchIfKeyExists:aKey];

    if (value != nil) {
        if ([self validateValue:value type:[NSNumber class] configKey:aKey]) {
            return [value floatValue];
        }
    }

    return 0.0f;
}

- (double)doubleValue:(NSString *)aKey
{
    id value = [self fetchIfKeyExists:aKey];

    if (value != nil) {
        if ([self validateValue:value type:[NSNumber class] configKey:aKey]) {
            return [value doubleValue];
        }
    }

    return 0.0;
}

- (CGPoint)pointValue:(NSString *)aKey
{
    id value = [self fetchIfKeyExists:aKey];

    if (value != nil) {
        if ([self validateValue:value type:[NSDictionary class] configKey:aKey]) {

            NSDictionary *map = value;

            if ([self validateDictionary:map keys:@[@"x", @"y"] type:[NSNumber class] configKey:aKey]) {

                CGPoint point;

                point.x = [map[@"x"] floatValue];
                point.y = [map[@"y"] floatValue];

                return point;
            }
        }
    }

    return CGPointZero;
}

- (CGSize)sizeValue:(NSString *)aKey
{
    id value = [self fetchIfKeyExists:aKey];

    if (value != nil) {
        if ([self validateValue:value type:[NSDictionary class] configKey:aKey]) {

            NSDictionary *map = value;

            if ([self validateDictionary:map keys:@[@"width", @"height"] type:[NSNumber class] configKey:aKey]) {

                CGSize size;

                size.width = [map[@"width"] floatValue];
                size.height = [map[@"height"] floatValue];

                return size;
            }
        }
    }

    return CGSizeZero;
}

- (CGRect)rectValue:(NSString *)aKey
{
    id value = [self fetchIfKeyExists:aKey];

    if (value != nil) {
        if ([self validateValue:value type:[NSDictionary class] configKey:aKey]) {

            NSDictionary *map = value;

            if ([self validateDictionary:map keys:@[@"x", @"y", @"width", @"height"] type:[NSNumber class] configKey:aKey]) {

                CGRect rect;

                rect.origin.x = [map[@"x"] floatValue];
                rect.origin.y = [map[@"y"] floatValue];
                rect.size.width = [map[@"width"] floatValue];
                rect.size.height = [map[@"height"] floatValue];

                return rect;
            }
        }
    }

    return CGRectZero;
}

- (UIEdgeInsets)insetsValue:(NSString *)aKey
{
    id value = [self fetchIfKeyExists:aKey];

    if (value != nil) {
        if ([self validateValue:value type:[NSDictionary class] configKey:aKey]) {

            NSDictionary *map = value;

            if ([self validateDictionary:map keys:@[@"top", @"bottom", @"left", @"right"] type:[NSNumber class] configKey:aKey]) {

                UIEdgeInsets insets;

                insets.top = [map[@"top"] floatValue];
                insets.bottom = [map[@"bottom"] floatValue];
                insets.left = [map[@"left"] floatValue];
                insets.right = [map[@"right"] floatValue];

                return insets;
            }
        }
    }

    return UIEdgeInsetsZero;
}

- (UIColor *)colorValue:(NSString *)aKey
{
    id value = [self fetchIfKeyExists:aKey];

    if (value != nil) {
        if ([self validateValue:value type:[NSDictionary class] configKey:aKey]) {

            NSDictionary *map = value;

            if ([self validateDictionary:map keys:@[@"red", @"green", @"blue", @"alpha"] type:[NSNumber class] configKey:aKey]) {
                return [UIColor colorWithRed:([map[@"red"] intValue] / 255.0f)
                                       green:([map[@"green"] intValue] / 255.0f)
                                        blue:([map[@"blue"] intValue] / 255.0f)
                                       alpha:([map[@"alpha"] intValue] / 255.0f)];
            }
        }
    }

    return nil;
}

- (BOOL)containsValue:(NSString *)aKey
{
    return dictionary[aKey] != nil;
}

#pragma mark - Private

- (id)fetchIfKeyExists:(NSString *)aKey
{
    id value = dictionary[aKey];

    if (value == nil) {
        DDLogWarn(@"No value found for key [%@].", aKey);
    }

    return value;
}

- (BOOL)validateValue:(id)aValue type:(Class)aType configKey:(NSString *)aConfigKey
{
    if ([aValue isKindOfClass:aType]) {
        return YES;
    } else {
        DDLogWarn(@"Value is expected to be [%@] for key [%@].", NSStringFromClass(aType), aConfigKey);
    }

    return NO;
}

- (BOOL)validateDictionary:(NSDictionary *)aDictionary keys:(NSArray *)aKeys type:(Class)aClass configKey:(NSString *)aConfigKey
{
    for (NSString *key in aKeys) {

        id value = aDictionary[key];

        if (value != nil && ![value isKindOfClass:aClass]) {

            DDLogWarn(@"[NSDictionary] values [%@] are expected to be [%@] for key [%@].", aKeys, NSStringFromClass(aClass), aConfigKey);

            return NO;
        }
    }

    return YES;
}

@end