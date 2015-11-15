//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYMappingCacheSerializer.h"
#import <EasyMapping/EKMappingProtocol.h>
#import <EasyMapping/EKMapper.h>
#import <EasyMapping/EKRelationshipMapping.h>
#import <EasyMapping/EKSerializer.h>
#import "PNYErrorUtils.h"
#import "PNYMacros.h"

@implementation PNYMappingCacheSerializer

static const NSPropertyListFormat PLIST_FORMAT = NSPropertyListBinaryFormat_v1_0;

+ (instancetype)mappingCacheSerializerWithValueClass:(Class)aValueClass
{
    return [[self alloc] initWithValueClass:aValueClass];
}

- (instancetype)initWithValueClass:(Class)aValueClass{
    self = [super init];
    if (self != nil) {
        _valueClass = aValueClass;
    }
    return self;
}

#pragma mark - <PNYCacheSerializer>

- (NSData *)serializeValue:(id)aValue
{
    PNYAssert(self.valueClass != nil);

    NSData *serializedValue = nil;

    if ([aValue isKindOfClass:[NSArray class]]) {

        NSArray *mappedArray = [EKSerializer serializeCollection:aValue
                                                     withMapping:[self.valueClass objectMapping]];

        serializedValue = [NSPropertyListSerialization dataWithPropertyList:mappedArray format:PLIST_FORMAT
                                                                    options:0 error:nil];

    } else if ([aValue conformsToProtocol:@protocol(EKMappingProtocol)]) {

        NSDictionary *mappedValue = [EKSerializer serializeObject:aValue
                                                      withMapping:[self.valueClass objectMapping]];

        serializedValue = [NSPropertyListSerialization dataWithPropertyList:mappedValue format:PLIST_FORMAT
                                                                    options:0 error:nil];

    } else {
        @throw [PNYErrorUtils exceptionForObject:self message:@"NSArray or EKMappingProtocol value expected."];
    }

    return serializedValue;
}

- (id)unserializeValue:(NSData *)aValue
{
    PNYAssert(self.valueClass != nil);

    id mappedValue = [NSPropertyListSerialization propertyListWithData:aValue options:NSPropertyListImmutable
                                                                format:nil error:nil];

    id unserializedValue = nil;
    if ([mappedValue isKindOfClass:[NSArray class]]) {
        unserializedValue = [EKMapper arrayOfObjectsFromExternalRepresentation:mappedValue
                                                                   withMapping:[self.valueClass objectMapping]];
    } else if ([mappedValue isKindOfClass:[NSDictionary class]]) {
        unserializedValue = [EKMapper objectFromExternalRepresentation:mappedValue
                                                           withMapping:[self.valueClass objectMapping]];
    } else {
        @throw [PNYErrorUtils exceptionForObject:self message:@"NSArray or NSDictionary value expected."];
    }

    return unserializedValue;
}

@end