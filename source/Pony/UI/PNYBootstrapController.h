//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapService.h"
#import "PNYBootstrapConfigController.h"
#import "PNYBootstrapRetryController.h"

@interface PNYBootstrapController : UIViewController <PNYBootstrapServiceDelegate, PNYBootstrapConfigControllerDelegate, PNYBootstrapRetryControllerDelegate>

@property (nonatomic, strong) PNYBootstrapService *bootstrapService;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)unwindBootstrapFromMain:(UIStoryboardSegue *)aSegue;

@end