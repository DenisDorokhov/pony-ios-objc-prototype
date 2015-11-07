//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYConfig.h"
#import "PNYEventBus.h"
#import "PNYBootstrapService.h"

@interface PNYBootstrapViewController : UIViewController

@property (nonatomic, strong) PNYBootstrapService *bootstrapService;

@end