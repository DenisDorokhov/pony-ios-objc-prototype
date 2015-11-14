//
// Created by Denis Dorokhov on 14/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYBootstrapChildControllerAbstract.h"
#import "PNYBootstrapChildControllerAbstract+Protected.h"

@implementation PNYBootstrapChildControllerAbstract
{
@private
    BOOL _active;
}

#pragma mark - <PNYBootstrapConfigController>

- (BOOL)active
{
    return _active;
}

- (void)setActive:(BOOL)aActive
{
    if (_active != aActive) {

        _active = aActive;

        if (_active) {
            [self activate];
        } else {
            [self passivate];
        }
    }
}

#pragma mark - Protected

- (void)activate
{
    // Do nothing by default.
}

- (void)passivate
{
    // Do nothing by default.
}

@end