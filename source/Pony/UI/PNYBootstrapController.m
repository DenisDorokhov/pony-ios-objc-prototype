//
//  PNYBootstrapController.m
//  Pony
//
//  Created by Denis Dorokhov on 11/10/15.
//  Copyright © 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapController.h"
#import "PNYBootstrapServerController.h"
#import "PNYBootstrapAuthenticationController.h"

typedef NS_ENUM(NSInteger, PNYBootstraoControllerState)
{
    PNYBootstrapControllerStateBootstrapStarted,
    PNYBootstrapControllerStateBootstrapActivity,
    PNYBootstrapControllerStateServerRequired,
    PNYBootstrapControllerStateServerActivity,
    PNYBootstrapControllerStateServerRetry,
    PNYBootstrapControllerStateAuthenticationRequired,
    PNYBootstrapControllerStateAuthenticationActivity,
    PNYBootstrapControllerStateAuthenticationRetry,
    PNYBootstrapControllerStateBootstrapped,
};

@interface PNYBootstrapController ()

@property(nonatomic) PNYBootstraoControllerState state;

@end

@implementation PNYBootstrapController
{
@private
    PNYBootstrapServerController *bootstrapServerController;
    PNYBootstrapAuthenticationController *bootstrapAuthenticationController;
    PNYBootstrapRetryController *bootstrapRetryController;
}

#pragma mark - <PNYBootstrapServiceDelegate>

- (void)bootstrapServiceDidStartBootstrap:(PNYBootstrapService *)aBootstrapService
{
    self.state = PNYBootstrapControllerStateBootstrapStarted;
}

- (void)bootstrapServiceDidFinishBootstrap:(PNYBootstrapService *)aBootstrapService
{
    self.state = PNYBootstrapControllerStateBootstrapped;
}

- (void)bootstrapServiceDidStartBackgroundActivity:(PNYBootstrapService *)aBootstrapService
{
    self.state = PNYBootstrapControllerStateBootstrapActivity;
}

- (void)bootstrapServiceDidRequireRestUrl:(PNYBootstrapService *)aBootstrapService
{
    self.state = PNYBootstrapControllerStateServerRequired;
}

- (void)bootstrapServiceDidRequireAuthentication:(PNYBootstrapService *)aBootstrapService
{
    self.state = PNYBootstrapControllerStateAuthenticationRequired;
}

- (void)bootstrapService:(PNYBootstrapService *)aBootstrapService didFailRestServiceRequestWithErrors:(NSArray *)aErrors
{
    self.state = PNYBootstrapControllerStateServerRequired;
}

- (void)bootstrapService:(PNYBootstrapService *)aBootstrapService didFailAuthenticationRequestWithErrors:(NSArray *)aErrors
{
    self.state = PNYBootstrapControllerStateAuthenticationRequired;
}

#pragma mark - <PNYBootstrapStepController>

- (void)bootstrapStepControllerDidStartBackgroundActivity:(id <PNYBootstrapStepController>)aStepController
{
    if (aStepController == bootstrapServerController) {
        self.state = PNYBootstrapControllerStateServerActivity;
    } else if (aStepController == bootstrapAuthenticationController) {
        self.state = PNYBootstrapControllerStateAuthenticationActivity;
    }
}

- (void)bootstrapStepControllerDidFinishBackgroundActivity:(id <PNYBootstrapStepController>)aStepController
{
    if (aStepController == bootstrapServerController) {
        self.state = PNYBootstrapControllerStateServerRequired;
    } else if (aStepController == bootstrapAuthenticationController) {
        self.state = PNYBootstrapControllerStateAuthenticationRequired;
    }
}

- (void)bootstrapStepControllerDidFailBackgroundActivity:(id <PNYBootstrapStepController>)aStepController
{
    if (aStepController == bootstrapServerController) {
        self.state = PNYBootstrapControllerStateServerRetry;
    } else if (aStepController == bootstrapAuthenticationController) {
        self.state = PNYBootstrapControllerStateAuthenticationRetry;
    }
}

- (void)bootstrapStepControllerDidRequestBootstrap:(id <PNYBootstrapStepController>)aStepController
{
    [self.bootstrapService bootstrap];
}

#pragma mark - <PNYBootstrapRetryControllerDelegate>

- (void)bootstrapRetryControllerDidRequestRetry:(PNYBootstrapRetryController *)aRetryController
{
    if (self.state == PNYBootstrapControllerStateServerRetry) {
        [bootstrapServerController retry];
    } else if (self.state == PNYBootstrapControllerStateAuthenticationRetry) {
        [bootstrapAuthenticationController retry];
    }
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.bootstrapService != nil);

    PNYAssert(self.serverStepContainer != nil);
    PNYAssert(self.authenticationStepContainer != nil);
    PNYAssert(self.retryContainer != nil);

    PNYAssert(bootstrapServerController != nil);
    PNYAssert(bootstrapAuthenticationController != nil);

    self.bootstrapService.delegate = self;

    bootstrapServerController.delegate = self;
    bootstrapAuthenticationController.delegate = self;
    bootstrapRetryController.delegate = self;

    self.activityIndicator.alpha = 0;
    self.serverStepContainer.alpha = 0;
    self.authenticationStepContainer.alpha = 0;
    self.retryContainer.alpha = 0;

    [self.bootstrapService bootstrap];
}

- (void)prepareForSegue:(UIStoryboardSegue *)aSegue sender:(id)aSender
{
    [super prepareForSegue:aSegue sender:aSender];

    if ([aSegue.destinationViewController isKindOfClass:[PNYBootstrapServerController class]]) {
        bootstrapServerController = (id)aSegue.destinationViewController;
    } else if ([aSegue.destinationViewController isKindOfClass:[PNYBootstrapAuthenticationController class]]) {
        bootstrapAuthenticationController = (id)aSegue.destinationViewController;
    } else if ([aSegue.destinationViewController isKindOfClass:[PNYBootstrapRetryController class]]) {
        bootstrapRetryController = (id)aSegue.destinationViewController;
    }
}

#pragma mark - Private

- (void)setState:(PNYBootstraoControllerState)aState
{
    _state = aState;

    CGFloat activityIndicatorAlpha;
    CGFloat serverStepContainerAlpha;
    CGFloat authenticationStepContainerAlpha;
    CGFloat retryContainerAlpha;

    switch (self.state) {
        case PNYBootstrapControllerStateBootstrapStarted: {
            activityIndicatorAlpha = 0.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 0.0f;
            retryContainerAlpha = 0.0f;
            break;
        }
        case PNYBootstrapControllerStateBootstrapActivity: {
            activityIndicatorAlpha = 1.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 0.0f;
            retryContainerAlpha = 0.0f;
            break;
        }
        case PNYBootstrapControllerStateServerRequired: {
            activityIndicatorAlpha = 0.0f;
            serverStepContainerAlpha = 1.0f;
            authenticationStepContainerAlpha = 0.0f;
            retryContainerAlpha = 0.0f;
            break;
        }
        case PNYBootstrapControllerStateServerActivity: {
            activityIndicatorAlpha = 1.0f;
            serverStepContainerAlpha = 0.8f;
            authenticationStepContainerAlpha = 0.0f;
            retryContainerAlpha = 0.0f;
            break;
        }
        case PNYBootstrapControllerStateServerRetry: {
            activityIndicatorAlpha = 0.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 0.8f;
            retryContainerAlpha = 1.0f;
            break;
        }
        case PNYBootstrapControllerStateAuthenticationRequired: {
            activityIndicatorAlpha = 0.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 1.0f;
            retryContainerAlpha = 0.0f;
            break;
        }
        case PNYBootstrapControllerStateAuthenticationActivity: {
            activityIndicatorAlpha = 1.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 0.8f;
            retryContainerAlpha = 0.0f;
            break;
        }
        case PNYBootstrapControllerStateAuthenticationRetry: {
            activityIndicatorAlpha = 0.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 0.8f;
            retryContainerAlpha = 1.0f;
            break;
        }
        case PNYBootstrapControllerStateBootstrapped: {
            activityIndicatorAlpha = 0.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 0.0f;
            retryContainerAlpha = 0.0f;
            break;
        }
    }

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.activityIndicator.alpha = activityIndicatorAlpha;
                         self.serverStepContainer.alpha = serverStepContainerAlpha;
                         self.authenticationStepContainer.alpha = authenticationStepContainerAlpha;
                         self.retryContainer.alpha = retryContainerAlpha;
                     } completion:nil];
}

@end