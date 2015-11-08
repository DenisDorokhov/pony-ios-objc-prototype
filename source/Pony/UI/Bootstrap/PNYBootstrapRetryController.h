//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@class PNYBootstrapRetryController;

@protocol PNYBootstrapRetryControllerDelegate <NSObject>

- (void)bootstrapRetryControllerDidRequestRetry:(PNYBootstrapRetryController *)aRetryController;

@end

@interface PNYBootstrapRetryController : UIViewController

@property (nonatomic, weak) id <PNYBootstrapRetryControllerDelegate> delegate;

@property (nonatomic, strong) IBOutlet UILabel *retryLabel;
@property (nonatomic, strong) IBOutlet UIButton *retryButton;

- (IBAction)onRetryButtonTouch;

@end