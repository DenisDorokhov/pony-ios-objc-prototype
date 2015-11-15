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
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:PNYLocalized(@"alertFactory_buttonOK")
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];

    return alertController;
}

+ (UIAlertController *)createOKCancelAlertWithTitle:(NSString *)aTitle message:(NSString *)aMessage
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:aTitle message:aMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:PNYLocalized(@"alertFactory_buttonOK")
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:PNYLocalized(@"alertFactory_buttonCancel")
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];

    return alertController;
}

@end