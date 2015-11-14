//
//  PNYBootstrapController.m
//  Pony
//
//  Created by Denis Dorokhov on 11/10/15.
//  Copyright © 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapController.h"
#import "PNYBootstrapServerConfigController.h"
#import "PNYBootstrapLoginConfigController.h"
#import "PNYSegues.h"

@interface PNYBootstrapController ()

@property (nonatomic, strong) UIViewController <PNYBootstrapConfigController> *currentConfigController;
@property (nonatomic) BOOL backgroundActivityStarted;

@end

@implementation PNYBootstrapController
{
@private
    PNYBootstrapServerConfigController *bootstrapServerConfigController;
    PNYBootstrapLoginConfigController *bootstrapLoginConfigController;
    PNYBootstrapRetryController *bootstrapRetryController;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - <PNYBootstrapServiceDelegate>

- (void)bootstrapServiceDidStartBootstrap:(PNYBootstrapService *)aBootstrapService
{
    self.currentConfigController = nil;
}

- (void)bootstrapServiceDidFinishBootstrap:(PNYBootstrapService *)aBootstrapService
{
    self.backgroundActivityStarted = NO;

    [self performSegueWithIdentifier:PNYSegueBootstrapToMain sender:self];
}

- (void)bootstrapServiceDidStartBackgroundActivity:(PNYBootstrapService *)aBootstrapService
{
    self.backgroundActivityStarted = YES;
}

- (void)bootstrapServiceDidRequireRestUrl:(PNYBootstrapService *)aBootstrapService
{
    self.backgroundActivityStarted = NO;
    self.currentConfigController = bootstrapServerConfigController;
}

- (void)bootstrapServiceDidRequireAuthentication:(PNYBootstrapService *)aBootstrapService
{
    self.backgroundActivityStarted = NO;
    self.currentConfigController = bootstrapLoginConfigController;
}

- (void)bootstrapService:(PNYBootstrapService *)aBootstrapService didFailWithErrors:(NSArray *)aErrors
{
    self.backgroundActivityStarted = NO;

    self.currentConfigController = nil;

    [self showView:bootstrapRetryController.view.superview];
}

#pragma mark - <PNYBootstrapConfigController>

- (void)bootstrapConfigControllerDidStartBackgroundActivity:(id <PNYBootstrapConfigController>)aStepController
{
    self.backgroundActivityStarted = YES;
}

- (void)bootstrapConfigControllerDidFinishBackgroundActivity:(id <PNYBootstrapConfigController>)aStepController
{
    self.backgroundActivityStarted = NO;
}

- (void)bootstrapConfigControllerDidRequestOtherServer:(id <PNYBootstrapConfigController>)aStepController
{
    self.backgroundActivityStarted = NO;

    [self clearBootstrapData];
}

- (void)bootstrapConfigControllerDidRequestBootstrap:(id <PNYBootstrapConfigController>)aStepController
{
    [self.bootstrapService bootstrap];
}

#pragma mark - <PNYBootstrapRetryControllerDelegate>

- (void)bootstrapRetryControllerDidRequestRetry:(PNYBootstrapRetryController *)aRetryController
{
    [self.bootstrapService bootstrap];
}

- (void)bootstrapRetryControllerDidRequestOtherServer:(PNYBootstrapRetryController *)aRetryController
{
    [self hideView:bootstrapRetryController.view.superview];

    [self clearBootstrapData];
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.bootstrapService != nil);

    PNYAssert(bootstrapServerConfigController != nil);
    PNYAssert(bootstrapLoginConfigController != nil);
    PNYAssert(bootstrapRetryController != nil);

    self.bootstrapService.delegate = self;

    bootstrapServerConfigController.delegate = self;
    bootstrapLoginConfigController.delegate = self;
    bootstrapRetryController.delegate = self;

    self.activityIndicator.alpha = 0;

    bootstrapServerConfigController.view.superview.alpha = 0;
    bootstrapLoginConfigController.view.superview.alpha = 0;
    bootstrapRetryController.view.superview.alpha = 0;

    [self.activityIndicator startAnimating];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];

    [self.bootstrapService bootstrap];
}

- (void)prepareForSegue:(UIStoryboardSegue *)aSegue sender:(id)aSender
{
    [super prepareForSegue:aSegue sender:aSender];

    if ([aSegue.destinationViewController isKindOfClass:[PNYBootstrapServerConfigController class]]) {
        bootstrapServerConfigController = (id)aSegue.destinationViewController;
    } else if ([aSegue.destinationViewController isKindOfClass:[PNYBootstrapLoginConfigController class]]) {
        bootstrapLoginConfigController = (id)aSegue.destinationViewController;
    } else if ([aSegue.destinationViewController isKindOfClass:[PNYBootstrapRetryController class]]) {
        bootstrapRetryController = (id)aSegue.destinationViewController;
    }
}

#pragma mark - Private

- (void)clearBootstrapData
{
    [self.bootstrapService clearBootstrapData];
    [self.bootstrapService bootstrap];
}

- (void)setCurrentConfigController:(UIViewController <PNYBootstrapConfigController> *)currentConfigController
{
    UIViewController <PNYBootstrapConfigController> *oldController = _currentConfigController;

    _currentConfigController = currentConfigController;

    oldController.active = NO;

    [self hideView:oldController.view.superview];

    _currentConfigController.active = YES;

    [self showView:_currentConfigController.view.superview];
}

- (void)setBackgroundActivityStarted:(BOOL)aBackgroundActivityStarted
{
    if (_backgroundActivityStarted != aBackgroundActivityStarted) {

        _backgroundActivityStarted = aBackgroundActivityStarted;

        if (_backgroundActivityStarted) {
            [self showView:self.activityIndicator];
        } else {
            [self hideView:self.activityIndicator];
        }
    }
}

- (void)hideView:(UIView *)aView
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         aView.alpha = 0.0f;
                     } completion:nil];
}

- (void)showView:(UIView *)aView
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         aView.alpha = 1.0f;
                     } completion:nil];
}

- (void)onKeyboardDidShow:(NSNotification*)aNotification
{
    NSDictionary *info = [aNotification userInfo];

    CGSize keyboardSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    self.scrollView.contentInset = self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
}

- (void)onKeyboardWillHide:(NSNotification*)aNotification
{
    self.scrollView.contentInset = self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

@end