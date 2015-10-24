//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAbstractDto.h"

@implementation PNYAbstractDto

- (NSUInteger)hash
{
    return self.id != nil ? [self.id hash] : [super hash];
}

- (BOOL)isEqual:(id)aObj
{
    if (aObj == self) {
        return YES;
    }

    if (aObj != nil && self.id != nil && [[self class] isEqual:[aObj class]]) {

        PNYAbstractDto *dto = (PNYAbstractDto *)aObj;

        return [self.id isEqual:dto.id];
    }

    return NO;
}

@end