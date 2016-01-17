//
// Created by Denis Dorokhov on 17/01/16.
// Copyright (c) 2016 Denis Dorokhov. All rights reserved.
//

#import "UIView+PNYInterfaceBuilder.h"

@implementation UIView (PNYInterfaceBuilder)

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)aCornerRadius
{
    self.layer.cornerRadius = aCornerRadius;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)aBorderWidth
{
    self.layer.borderWidth = aBorderWidth;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)aBorderColor
{
    self.layer.borderColor = aBorderColor.CGColor;
}

- (CGSize)shadowOffset
{
    return self.layer.shadowOffset;
}

- (void)setShadowOffset:(CGSize)aShadowOffset
{
    self.layer.shadowOffset = aShadowOffset;
}

- (CGFloat)shadowOpacity
{
    return self.layer.shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)aShadowOpacity
{
    self.layer.shadowOpacity = aShadowOpacity;
}

- (CGFloat)shadowRadius
{
    return self.layer.shadowRadius;
}

- (void)setShadowRadius:(CGFloat)aShadowRadius
{
    self.layer.shadowRadius = aShadowRadius;
}

- (UIColor *)shadowColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowColor:(UIColor *)aShadowColor
{
    self.layer.shadowColor = aShadowColor.CGColor;
}

@end