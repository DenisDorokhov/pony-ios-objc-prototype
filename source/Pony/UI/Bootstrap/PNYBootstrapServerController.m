//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapServerController.h"

@implementation PNYBootstrapServerController

@synthesize delegate = _delegate;

#pragma mark - Public

- (IBAction)onSaveButtonTouch
{
    [self saveAndValidate];
}

#pragma mark - <PNYBootstrapStepController>

- (void)reset
{
    NSURL *url = [self.restServiceUrlDao fetchUrl];

    self.serverText.text = [self urlToString:url];
    self.httpsSwitch.on = [url.scheme isEqualToString:@"https"];
}

- (void)retry
{
    // TODO: implement
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    if (aTextField == self.serverText) {
        [self.serverText resignFirstResponder];
        [self saveAndValidate];
    }

    return YES;
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.restServiceUrlDao != nil);
    PNYAssert(self.restService != nil);

    self.serverLabel.text = PNYLocalized(@"bootstrap.server.serverLabel");
    self.httpsLabel.text = PNYLocalized(@"bootstrap.server.httpsLabel");

    [self.saveButton setTitle:PNYLocalized(@"bootstrap.server.saveButton") forState:UIControlStateNormal];
}

#pragma mark - Private

- (void)saveAndValidate
{
    // TODO: implement
}

- (NSString *)urlToString:(NSURL *)aUrl
{
    if (aUrl == nil) {
        return @"";
    }

    NSMutableString *result = [NSMutableString stringWithString:[aUrl host]];

    BOOL isStandardHttp = [aUrl.scheme isEqualToString:@"http"] && [aUrl.port isEqualToNumber:@80];
    BOOL isStandardHttpSecure = [aUrl.scheme isEqualToString:@"https"] && [aUrl.port isEqualToNumber:@443];

    if (!isStandardHttp && !isStandardHttpSecure) {
        [result appendFormat:@":%@", aUrl.port];
    }

    [result appendString:aUrl.path];

    return result;
}

@end