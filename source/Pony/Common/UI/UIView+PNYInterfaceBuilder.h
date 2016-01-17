//
// Created by Denis Dorokhov on 17/01/16.
// Copyright (c) 2016 Denis Dorokhov. All rights reserved.
//

@interface UIView (PNYInterfaceBuilder)

@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;

@property (nonatomic) IBInspectable CGSize shadowOffset;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable UIColor *shadowColor;

@end