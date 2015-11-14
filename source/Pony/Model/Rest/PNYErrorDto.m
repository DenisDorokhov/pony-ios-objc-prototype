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

#pragma mark - Public

+ (NSArray *)fetchArrayOfErrorsFromArray:(NSArray *)aErrors withCodes:(NSArray *)aCodes
{
    NSMutableArray *result = [NSMutableArray array];

    for (PNYErrorDto *error in aErrors) {
        for (NSString *code in aCodes) {
            if ([error.code isEqualToString:code] || [error.code hasPrefix:[NSString stringWithFormat:@"%@.", code]]) {
                [result addObject:error];
            }
        }
    }

    return result;
}

+ (PNYErrorDto *)fetchErrorFromArray:(NSArray *)aErrors withCodes:(NSArray *)aCodes
{
    NSArray *errors = [self fetchArrayOfErrorsFromArray:aErrors withCodes:aCodes];

    return [errors count] > 0 ? errors[0] : nil;
}

#pragma mark - <EKMappingProtocol>

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"field", @"code", @"text", @"arguments"]];
    }];
}

#pragma mark - Override

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"code=%@", self.code];
    [description appendFormat:@", text=%@", self.text];
    [description appendFormat:@", field=%@", self.field];
    [description appendFormat:@", arguments=%@", self.arguments];
    [description appendString:@">"];
    return description;
}

@end