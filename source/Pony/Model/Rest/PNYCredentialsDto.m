//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCredentialsDto.h"

@implementation PNYCredentialsDto

#pragma mark - <EKMappingProtocol>

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *aMapping) {
        [aMapping mapPropertiesFromArray:@[@"email", @"password"]];
    }];
}

@end