//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface PNYAlertFactory : NSObject

+ (UIAlertController *)createOKAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage;
+ (UIAlertController *)createOKCancelAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage;

@end