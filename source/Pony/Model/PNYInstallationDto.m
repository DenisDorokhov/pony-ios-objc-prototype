//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYInstallationDto.h"

@implementation PNYInstallationDto

- (NSUInteger)hash
{
    return self.version != nil ? [self.version hash] : [super hash];
}

- (BOOL)isEqual:(id)aObj
{
    if (aObj == self) {
        return YES;
    }

    if (aObj != nil && self.version != nil && [[self class] isEqual:[aObj class]]) {

        PNYInstallationDto *dto = (PNYInstallationDto *)aObj;

        return [self.version isEqualToString:dto.version];
    }

    return NO;
}

@end