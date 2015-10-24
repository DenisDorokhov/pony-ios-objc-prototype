//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYErrorDto.h"

@implementation PNYErrorDto

+ (instancetype)errorWithCode:(NSString *)aCode text:(NSString *)aText arguments:(NSArray *)aArguments
{
    return [[self alloc] initWithCode:aCode text:aText arguments:aArguments];
}

- (instancetype)initWithCode:(NSString *)aCode text:(NSString *)aText arguments:(NSArray *)aArguments
{
    self = [self init];
    if (self != nil) {
        self.code = aCode;
        self.text = aText;
        self.arguments = aArguments;
    }
    return self;
}

#pragma mark - <EKMappingProtocol>

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"field", @"code", @"text", @"arguments"]];
    }];
}

@end