//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKMapper.h>
#import <EasyMapping/EKRelationshipMapping.h>
#import "PNYRestResponseSerializer.h"
#import "PNYMacros.h"
#import "PNYErrorUtils.h"
#import "PNYResponseDto.h"
#import "PNYErrorDto.h"

@implementation PNYRestResponseSerializer

+ (instancetype)serializerWithDataClass:(Class)aDataClass
{
    return [[self alloc] initWithDataClass:aDataClass];
}

+ (instancetype)serializerWithDataClass:(Class)aDataClass dataContainerClass:(Class)aDataContainerClass
{
    return [[self alloc] initWithDataClass:aDataClass dataContainerClass:aDataContainerClass];
}

- (instancetype)initWithDataClass:(Class)aDataClass
{
    return [self initWithDataClass:aDataClass dataContainerClass:nil];
}

- (instancetype)initWithDataClass:(Class)aDataClass dataContainerClass:(Class)aDataContainerClass
{
    PNYAssert(aDataClass != nil);

    self = [super init];
    if (self != nil) {
        _dataClass = aDataClass;
        _dataContainerClass = aDataContainerClass;
    }
    return self;
}

#pragma mark - Override

- (id)responseObjectForResponse:(NSURLResponse *)aResponse data:(NSData *)aData error:(NSError **)aError
{
    NSDictionary *responseObject = [super responseObjectForResponse:aResponse data:aData error:aError];

    if (*aError != nil) {
        return nil;
    }

    if (self.dataContainerClass != nil && self.dataContainerClass != [NSArray class]) {

        NSString *errorMessage = [NSString stringWithFormat:@"Data container class %@ is not supported.", NSStringFromClass(self.dataContainerClass)];

        *aError = [PNYErrorUtils errorForObject:self message:errorMessage];

        return nil;
    }

    return [self fromDictionary:responseObject];
}

#pragma mark - Private

- (PNYResponseDto *)fromDictionary:(NSDictionary *)aDictionary
{
    EKObjectMapping *mapping = [[EKObjectMapping alloc] initWithObjectClass:[PNYResponseDto class]];

    [mapping mapPropertiesFromArray:@[@"version", @"successful"]];
    [mapping hasMany:[PNYErrorDto class] forKeyPath:@"errors"];

    if (self.dataContainerClass == nil) {
        [mapping hasOne:self.dataClass forKeyPath:@"data"];
    } else {
        [mapping hasMany:self.dataClass forKeyPath:@"data"];
    }

    return [EKMapper objectFromExternalRepresentation:aDictionary withMapping:mapping];
}

@end