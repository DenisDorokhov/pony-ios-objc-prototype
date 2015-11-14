//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapServerConfigController.h"
#import "PNYBootstrapConfigControllerAbstract+Protected.h"
#import "PNYErrorDto.h"
#import "PNYAlertFactory.h"
#import "PNYBootstrapChildControllerAbstract+Protected.h"

@implementation PNYBootstrapServerConfigController

#pragma mark - Public

- (IBAction)onSaveButtonTouch
{
    [self save];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    if (aTextField == self.serverText) {
        [self.serverText resignFirstResponder];
        [self save];
    }

    return YES;
}

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];

    PNYAssert(self.restServiceUrlDao != nil);
    PNYAssert(self.restService != nil);

    self.serverLabel.text = PNYLocalized(@"bootstrapServerConfig_serverLabel");
    self.httpsLabel.text = PNYLocalized(@"bootstrapServerConfig_httpsLabel");

    [self.saveButton setTitle:PNYLocalized(@"bootstrapServerConfig_saveButton") forState:UIControlStateNormal];
}

- (void)activate
{
    [super activate];

    NSURL *url = [self.restServiceUrlDao fetchUrl];

    self.serverText.text = [self urlToString:url];
    self.httpsSwitch.on = [url.scheme isEqualToString:@"https"];
}

- (void)startBackgroundActivity
{
    [super startBackgroundActivity];

    self.view.userInteractionEnabled = NO;
}

- (void)finishBackgroundActivity
{
    [super finishBackgroundActivity];

    self.view.userInteractionEnabled = YES;
}

#pragma mark - Private

- (void)save
{
    NSString *url = [self formToUrl];

    if ([self validateUrl:url]) {

        [self.restServiceUrlDao storeUrl:[NSURL URLWithString:url]];

        [self startBackgroundActivity];

        [self.restService getInstallationWithSuccess:^(PNYInstallationDto *aInstallation) {

            [self finishBackgroundActivity];

            [self.delegate bootstrapConfigControllerDidRequestBootstrap:self];

        }                                    failure:^(NSArray *aErrors) {

            PNYLogError(@"Could get server installation: %@.", aErrors);

            [self finishBackgroundActivity];

            [self.restServiceUrlDao removeUrl];

            if ([PNYErrorDto fetchErrorFromArray:aErrors withCodes:@[PNYErrorDtoCodeClientOffline]] == nil) {
                [self showConnectionAlert];
            } else {
                [self showOfflineAlert];
            }
        }];

    } else {
        [self showValidationAlert];
    }
}

- (void)showValidationAlert
{
    [self presentViewController:[PNYAlertFactory createOKAlertWithTitle:PNYLocalized(@"bootstrapServerConfig_validationAlert_title")
                                                                message:PNYLocalized(@"bootstrapServerConfig_validationAlert_message")]
                       animated:YES completion:nil];
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

- (NSString *)formToUrl
{
    NSMutableString *url = [NSMutableString string];

    [url appendString:(self.httpsSwitch.on ? @"https://" : @"http://")];
    [url appendString:self.serverText.text];

    return url;
}

- (BOOL)validateUrl:(NSString *)aUrl
{
    NSString *regex = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];

    return [urlTest evaluateWithObject:aUrl];
}

@end