//
// Created by Denis Dorokhov on 11/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "CALayer+InterfaceBuilder.h"

@implementation CALayer (InterfaceBuilder)

- (void)setBorderUIColor:(UIColor *)aColor
{
    self.borderColor = aColor.CGColor;
}

- (UIColor *)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end