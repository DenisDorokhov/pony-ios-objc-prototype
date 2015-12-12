//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface PNYAlertFactory : NSObject

+ (UIAlertController *)createOKAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage;
+ (UIAlertController *)createOKAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage
                                      handler:(void (^)())aHandler;

+ (UIAlertController *)createOKCancelAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage
                                          okHandler:(void (^)())aOKHandler;
+ (UIAlertController *)createOKCancelAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage
                                          okHandler:(void (^)())aOKHandler cancelHandler:(void (^)())aCancelHandler;

@end