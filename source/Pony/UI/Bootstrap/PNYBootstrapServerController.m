//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapServerController.h"

@implementation PNYBootstrapServerController

@synthesize delegate = _delegate;

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.serverLabel.text = PNYLocalized(@"bootstrap.server.serverLabel");
    self.httpsLabel.text = PNYLocalized(@"bootstrap.server.httpsLabel");

    [self.saveButton setTitle:PNYLocalized(@"bootstrap.server.saveButton") forState:UIControlStateNormal];
}

@end