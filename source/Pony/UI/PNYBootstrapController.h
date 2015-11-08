//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapService.h"
#import "PNYBootstrapStepController.h"

@interface PNYBootstrapController : UIViewController <PNYBootstrapServiceDelegate, PNYBootstrapStepControllerDelegate>

@property (nonatomic, strong) PNYBootstrapService *bootstrapService;

@property (nonatomic, strong) IBOutlet UIView *serverStepContainer;
@property (nonatomic, strong) IBOutlet UIView *authenticationStepContainer;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

@end