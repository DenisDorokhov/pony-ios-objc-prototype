//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@protocol PNYConfig <NSObject>

- (NSString *)stringValue:(NSString *)aKey;
- (NSNumber *)numberValue:(NSString *)aKey;
- (BOOL)boolValue:(NSString *)aKey;
- (int)intValue:(NSString *)aKey;
- (float)floatValue:(NSString *)aKey;
- (double)doubleValue:(NSString *)aKey;

- (CGPoint)pointValue:(NSString *)aKey;
- (CGSize)sizeValue:(NSString *)aKey;
- (CGRect)rectValue:(NSString *)aKey;
- (UIEdgeInsets)insetsValue:(NSString *)aKey;
- (UIColor *)colorValue:(NSString *)aKey;

- (BOOL)containsValue:(NSString *)aKey;

@end