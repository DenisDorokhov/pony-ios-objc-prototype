//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapStepController.h"

@interface PNYBootstrapServerController : UIViewController <PNYBootstrapStepController>

@property (nonatomic, strong) IBOutlet UILabel *serverLabel;
@property (nonatomic, strong) IBOutlet UILabel *httpsLabel;
@property (nonatomic, strong) IBOutlet UITextField *serverText;
@property (nonatomic, strong) IBOutlet UISwitch *httpsSwitch;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;

@end