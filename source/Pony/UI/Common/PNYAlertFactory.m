//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAlertFactory.h"
#import "PNYMacros.h"

@implementation PNYAlertFactory

#pragma mark - Public

+ (UIAlertController *)createOKAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage
{
    return [self createOKAlertWithTitle:aTitle message:aMessage handler:nil];
}

+ (UIAlertController *)createOKAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage handler:(void (^)())aHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:PNYLocalized(@"alertFactory_buttonOK")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          if (aHandler != nil) {
                                                              aHandler();
                                                          }
                                                      }]];

    return alertController;
}

+ (UIAlertController *)createOKCancelAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage
                                          okHandler:(void (^)())aOKHandler
{
    return [self createOKCancelAlertWithTitle:aTitle message:aMessage okHandler:aOKHandler cancelHandler:nil];
}

+ (UIAlertController *)createOKCancelAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage okHandler:(void (^)())aOKHandler cancelHandler:(void (^)())aCancelHandler
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:PNYLocalized(@"alertFactory_buttonOK")
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          if (aOKHandler != nil) {
                                                              aOKHandler();
                                                          }
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:PNYLocalized(@"alertFactory_buttonCancel")
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *action) {
                                                          if (aCancelHandler != nil) {
                                                              aCancelHandler();
                                                          }
                                                      }]];

    return alertController;
}

@end