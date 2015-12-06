//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapChildControllerAbstract.h"

@class PNYBootstrapRetryController;

@protocol PNYBootstrapRetryControllerDelegate <NSObject>

- (void)bootstrapRetryControllerDidRequestRetry:(PNYBootstrapRetryController *)aRetryController;
- (void)bootstrapRetryControllerDidRequestOtherServer:(PNYBootstrapRetryController *)aRetryController;

@end

@interface PNYBootstrapRetryController : PNYBootstrapChildControllerAbstract

@property (nonatomic, weak) id <PNYBootstrapRetryControllerDelegate> delegate;

- (IBAction)onRetryButtonTouch;
- (IBAction)onOtherServerButtonTouch;

@end