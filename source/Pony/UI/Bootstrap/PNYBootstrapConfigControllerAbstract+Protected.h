//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapConfigControllerAbstract.h"

@interface PNYBootstrapConfigControllerAbstract (Protected)

- (void)activate;
- (void)passivate;

- (void)startBackgroundActivity;
- (void)finishBackgroundActivity;

- (void)showValidationAlert;
- (void)showConnectionAlert;
- (void)showOfflineAlert;

@end