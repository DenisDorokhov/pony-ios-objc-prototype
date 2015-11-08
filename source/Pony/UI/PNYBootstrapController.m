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
    PNYBootstrapControllerStateAuthenticationRequired,
    PNYBootstrapControllerStateAuthenticationActivity,
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

- (void)bootstrapService:(PNYBootstrapService *)aBootstrapService didFailRequestWithErrors:(NSArray *)aErrors
{
    self.state = PNYBootstrapControllerStateAuthenticationRequired;
}

#pragma mark - <PNYBootstrapStepController>

- (void)bootstrapStepControllerDidStartActivity:(id <PNYBootstrapStepController>)aStepController
{
    if (aStepController == bootstrapServerController) {
        self.state = PNYBootstrapControllerStateServerActivity;
    } else if (aStepController == bootstrapAuthenticationController) {
        self.state = PNYBootstrapControllerStateAuthenticationActivity;
    }
}

- (void)bootstrapStepControllerDidFinishActivity:(id <PNYBootstrapStepController>)aStepController
{
    [self.bootstrapService bootstrap];
}

- (void)bootstrapStepControllerDidFailActivity:(id <PNYBootstrapStepController>)aStepController
{
    if (aStepController == bootstrapServerController) {
        self.state = PNYBootstrapControllerStateServerRequired;
    } else if (aStepController == bootstrapAuthenticationController) {
        self.state = PNYBootstrapControllerStateAuthenticationRequired;
    }
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.bootstrapService != nil);

    PNYAssert(self.serverStepContainer != nil);
    PNYAssert(self.authenticationStepContainer != nil);

    PNYAssert(bootstrapServerController != nil);
    PNYAssert(bootstrapAuthenticationController != nil);

    self.bootstrapService.delegate = self;

    bootstrapServerController.delegate = self;
    bootstrapAuthenticationController.delegate = self;

    self.activityIndicator.alpha = 0;
    self.serverStepContainer.alpha = 0;
    self.authenticationStepContainer.alpha = 0;

    [self.bootstrapService bootstrap];
}

- (void)prepareForSegue:(UIStoryboardSegue *)aSegue sender:(id)aSender
{
    [super prepareForSegue:aSegue sender:aSender];

    if ([aSegue.destinationViewController isKindOfClass:[PNYBootstrapServerController class]]) {
        bootstrapServerController = (id)aSegue.destinationViewController;
    } else if ([aSegue.destinationViewController isKindOfClass:[PNYBootstrapAuthenticationController class]]) {
        bootstrapAuthenticationController = (id)aSegue.destinationViewController;
    }
}

#pragma mark - Private

- (void)setState:(PNYBootstraoControllerState)aState
{
    _state = aState;

    CGFloat activityIndicatorAlpha;
    CGFloat serverStepContainerAlpha;
    CGFloat authenticationStepContainerAlpha;

    switch (self.state) {
        case PNYBootstrapControllerStateBootstrapStarted:
        {
            activityIndicatorAlpha = 0.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 0.0f;
            break;
        }
        case PNYBootstrapControllerStateBootstrapActivity:
        {
            activityIndicatorAlpha = 1.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 0.0f;
            break;
        }
        case PNYBootstrapControllerStateServerRequired:
        {
            activityIndicatorAlpha = 0.0f;
            serverStepContainerAlpha = 1.0f;
            authenticationStepContainerAlpha = 0.0f;
            break;
        }
        case PNYBootstrapControllerStateServerActivity:
        {
            activityIndicatorAlpha = 1.0f;
            serverStepContainerAlpha = 0.8f;
            authenticationStepContainerAlpha = 0.0f;
            break;
        }
        case PNYBootstrapControllerStateAuthenticationRequired:
        {
            activityIndicatorAlpha = 0.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 1.0f;
            break;
        }
        case PNYBootstrapControllerStateAuthenticationActivity:
        {
            activityIndicatorAlpha = 1.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 0.8f;
            break;
        }
        case PNYBootstrapControllerStateBootstrapped:
        {
            activityIndicatorAlpha = 0.0f;
            serverStepContainerAlpha = 0.0f;
            authenticationStepContainerAlpha = 0.0f;
            break;
        }
    }

    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.activityIndicator.alpha = activityIndicatorAlpha;
                         self.serverStepContainer.alpha = serverStepContainerAlpha;
                         self.authenticationStepContainer.alpha = authenticationStepContainerAlpha;
                     } completion:nil];
}

@end