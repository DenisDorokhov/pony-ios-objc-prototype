//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYDataCacheSerializer.h"
#import "PNYImageCacheSerializer.h"
#import "PNYTestCase.h"
#import "PNYTestUtils.h"
#import "PNYStringCacheSerializer.h"
#import "PNYInstallationDto.h"
#import "PNYMappingCacheSerializer.h"
#import "PNYMemoryCache.h"
#import "PNYFileCache.h"
#import "PNYFileUtils.h"

@interface PNYCacheTests_MappedObject : NSObject <EKMappingProtocol>

@property (nonatomic, copy) NSString *property1;
@property (nonatomic, copy) NSString *property2;

@end

@implementation PNYCacheTests_MappedObject

+ (EKObjectMapping *)objectMapping
{
    return [EKObjectMapping mappingForClass:self withBlock:^(EKObjectMapping *mapping) {
        [mapping mapPropertiesFromArray:@[@"property1", @"property2"]];
    }];
}

@end

@interface PNYCacheTests : PNYTestCase

@end

@implementation PNYCacheTests

- (void)testDataSerializer
{
    PNYDataCacheSerializer *serializer = [PNYDataCacheSerializer new];

    assertThat(^{
        [serializer serializeValue:[NSObject new]];
    }, throwsException(anything()));

    NSData *value = [NSData data];

    assertThat([serializer serializeValue:value], equalTo(value));
    assertThat([serializer unserializeValue:value], equalTo(value));
}

- (void)testImageSerializer
{
    PNYImageCacheSerializer *serializer = [PNYImageCacheSerializer new];

    assertThat(^{
        [serializer serializeValue:[NSObject new]];
    }, throwsException(anything()));

    UIImage *value = [PNYTestUtils generateImageWithSize:CGSizeMake(10, 10)];

    assertThat([serializer serializeValue:value], notNilValue());
    assertThat([serializer unserializeValue:UIImagePNGRepresentation(value)], notNilValue());
}

- (void)testStringSerializer
{
    PNYStringCacheSerializer *serializer = [PNYStringCacheSerializer new];

    assertThat(^{
        [serializer serializeValue:[NSObject new]];
    }, throwsException(anything()));

    NSString *value = @"test";

    assertThat([serializer serializeValue:value], notNilValue());
    assertThat([serializer unserializeValue:[value dataUsingEncoding:NSUTF8StringEncoding]], equalTo(@"test"));
}

- (void)testMappingSerializer
{
    PNYMappingCacheSerializer *serializer = [[PNYMappingCacheSerializer alloc] initWithValueClass:[PNYCacheTests_MappedObject class]];

    assertThat(^{
        [serializer serializeValue:[NSObject new]];
    }, throwsException(anything()));

    NSData *data = [serializer serializeValue:[self buildMappedObject]];

    assertThat(data, notNilValue());

    PNYCacheTests_MappedObject *mappedObject = [serializer unserializeValue:data];

    [self assertMappedObject:mappedObject];

    data = [serializer serializeValue:@[[self buildMappedObject]]];

    assertThat(data, notNilValue());

    NSArray *mappedObjectArray = [serializer unserializeValue:data];

    assertThat(mappedObjectArray, hasCountOf(1));

    [self assertMappedObject:mappedObjectArray[0]];
}

- (void)testMemoryCache
{
    id <PNYCache> targetCache = mockProtocol(@protocol(PNYCache));

    [given([targetCache cachedValueForKey:@"someKey"]) willReturn:@"someValue"];
    [given([targetCache cachedValueExistsForKey:@"someKey"]) willReturn:@YES];

    PNYMemoryCache *memoryCache = [[PNYMemoryCache alloc] initWithTargetCache:targetCache];

    // Check if target cache is accessed.

    assertThatBool([memoryCache cachedValueExistsForKey:@"someKey"], isTrue());

    [verify(targetCache) cachedValueExistsForKey:@"someKey"];

    assertThat([memoryCache cachedValueForKey:@"someKey"], equalTo(@"someValue"));

    [verify(targetCache) cachedValueForKey:@"someKey"];

    // Check if target cache is not accessed again, since the value is in memory.

    assertThat([memoryCache cachedValueForKey:@"someKey"], equalTo(@"someValue"));

    [verifyCount(targetCache, times(1)) cachedValueForKey:@"someKey"];

    // Check if particular value is removed.

    [memoryCache cacheValue:@"otherValue" forKey:@"otherKey"];

    assertThat([memoryCache cachedValueForKey:@"otherKey"], notNilValue());

    [memoryCache removeCachedValueForKey:@"otherKey"];

    assertThat([memoryCache cachedValueForKey:@"otherKey"], nilValue());
    assertThat([memoryCache cachedValueForKey:@"someKey"], notNilValue());

    // Check if all values are removed.

    [memoryCache removeAllCachedValues];

    [given([targetCache cachedValueForKey:@"someKey"]) willReturn:nil];

    assertThat([memoryCache cachedValueForKey:@"someKey"], nilValue());
}

- (void)testCache
{
    PNYStringCacheSerializer *serializer = [PNYStringCacheSerializer new];

    PNYFileCache *cache = [[PNYFileCache alloc] initWithFolderPath:[PNYFileUtils filePathInDocuments:@"PNYCacheTests"]
                                                        serializer:serializer];

    [cache cacheValue:@"someValue" forKey:@"someKey"];

    assertThatBool([cache cachedValueExistsForKey:@"someKey"], isTrue());
    assertThat([cache cachedValueForKey:@"someKey"], equalTo(@"someValue"));

    [cache cacheValue:@"otherValue" forKey:@"otherKey"];

    [cache removeCachedValueForKey:@"otherKey"];

    assertThat([cache cachedValueForKey:@"otherKey"], nilValue());
    assertThat([cache cachedValueForKey:@"someKey"], equalTo(@"someValue"));

    [cache removeAllCachedValues];

    assertThat([cache cachedValueForKey:@"someKey"], nilValue());
}

#pragma mark - Private

- (PNYCacheTests_MappedObject *)buildMappedObject
{
    PNYCacheTests_MappedObject *mappedObject = [PNYCacheTests_MappedObject new];

    mappedObject.property1 = @"test1";
    mappedObject.property2 = @"test2";

    return mappedObject;
}

- (void)assertMappedObject:(PNYCacheTests_MappedObject *)aMappedObject
{
    assertThat(aMappedObject.property1, equalTo(@"test1"));
    assertThat(aMappedObject.property2, equalTo(@"test2"));
}

@end