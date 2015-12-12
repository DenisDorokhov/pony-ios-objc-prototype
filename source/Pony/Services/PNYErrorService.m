//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYErrorService.h"
#import "PNYErrorDto.h"
#import "PNYMacros.h"
#import "PNYAlertFactory.h"

@implementation PNYErrorService

- (void)reportErrors:(NSArray *)aErrors
{
    [self reportErrors:aErrors title:PNYLocalized(@"errorService_defaultTitle")];
}

- (void)reportErrors:(NSArray *)aErrors title:(NSString *)aTitle
{
    NSString *errorMessages = [[self errorsToMessages:aErrors] componentsJoinedByString:@"\n"];

    UIViewController *topViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    while (topViewController.presentedViewController != nil) {
        topViewController = topViewController.presentedViewController;
    }

    [topViewController presentViewController:[PNYAlertFactory createOKAlertWithTitle:aTitle message:errorMessages]
                                     animated:YES completion:nil];
}

#pragma mark - Private

- (NSArray *)errorsToMessages:(NSArray *)aErrors
{
    NSMutableArray *errorMessages = [NSMutableArray array];

    for (PNYErrorDto *error in aErrors) {

        NSString *localizationKey = [NSString stringWithFormat:@"error_%@", error.code];
        NSString *localizationValue = PNYLocalized(localizationKey);

        NSString *message = [localizationValue isEqualToString:localizationKey] ? error.text : localizationValue;

        [errorMessages addObject:message];
    }

    return errorMessages;
}

@end