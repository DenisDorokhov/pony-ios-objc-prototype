//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestUtils.h"

@implementation PNYTestUtils

#pragma mark - Public

+ (UIImage *)generateImageWithSize:(CGSize)aSize
{
    UIGraphicsBeginImageContextWithOptions(aSize, YES, 0);

    [[UIColor blackColor] setFill];

    UIRectFill(CGRectMake(0, 0, aSize.width, aSize.height));

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

@end