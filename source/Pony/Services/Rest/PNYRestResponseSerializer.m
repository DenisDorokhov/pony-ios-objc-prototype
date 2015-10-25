//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKMapper.h>
#import "PNYRestResponseSerializer.h"
#import "PNYResponseDto.h"

@implementation PNYRestResponseSerializer

+ (instancetype)serializerWithDataClass:(Class)aDataClass
{
    return [[self alloc] initWithDataClass:aDataClass];
}

- (instancetype)initWithDataClass:(Class)aDataClass
{
    self = [super init];
    if (self != nil) {

        _dataClass = aDataClass;

        NSMutableIndexSet *acceptableStatusCodes = [[NSMutableIndexSet alloc] initWithIndexSet:self.acceptableStatusCodes];

        [acceptableStatusCodes addIndex:400];
        [acceptableStatusCodes addIndex:401];
        [acceptableStatusCodes addIndex:404];
        [acceptableStatusCodes addIndex:500];

        self.acceptableStatusCodes = acceptableStatusCodes;
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

    return [EKMapper objectFromExternalRepresentation:responseObject
                                          withMapping:[PNYResponseDto objectMappingWithDataClass:self.dataClass]];
}

@end