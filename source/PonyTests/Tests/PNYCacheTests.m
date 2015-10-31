//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCacheSerializerData.h"
#import "PNYCacheSerializerImage.h"
#import "PNYTestCase.h"
#import "PNYTestUtils.h"
#import "PNYCacheSerializerString.h"
#import "PNYInstallationDto.h"
#import "PNYCacheSerializerMapping.h"
#import "PNYCacheMemory.h"
#import "PNYCacheImpl.h"
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
    PNYCacheSerializerData *serializer = [PNYCacheSerializerData new];

    XCTAssertThrows([serializer serializeValue:[NSObject new]]);

    NSData *value = [NSData data];

    XCTAssertEqual([serializer serializeValue:value], value);
    XCTAssertEqual([serializer unserializeValue:value], value);
}

- (void)testImageSerializer
{
    PNYCacheSerializerImage *serializer = [PNYCacheSerializerImage new];

    XCTAssertThrows([serializer serializeValue:[NSObject new]]);

    UIImage *value = [PNYTestUtils generateImageWithSize:CGSizeMake(10, 10)];

    XCTAssertNotNil([serializer serializeValue:value]);
    XCTAssertNotNil([serializer unserializeValue:UIImagePNGRepresentation(value)]);
}

- (void)testStringSerializer
{
    PNYCacheSerializerString *serializer = [PNYCacheSerializerString new];

    XCTAssertThrows([serializer serializeValue:[NSObject new]]);

    NSString *value = @"test";

    XCTAssertNotNil([serializer serializeValue:value]);
    XCTAssertEqualObjects([serializer unserializeValue:[value dataUsingEncoding:NSUTF8StringEncoding]], @"test");
}

- (void)testMappingSerializer
{
    PNYCacheSerializerMapping *serializer = [[PNYCacheSerializerMapping alloc] initWithValueClass:[PNYCacheTests_MappedObject class]];

    XCTAssertThrows([serializer serializeValue:[NSObject new]]);

    NSData *data = [serializer serializeValue:[self buildMappedObject]];

    XCTAssertNotNil(data);

    PNYCacheTests_MappedObject *mappedObject = [serializer unserializeValue:data];

    [self assertMappedObject:mappedObject];

    data = [serializer serializeValue:@[[self buildMappedObject]]];

    XCTAssertNotNil(data);

    NSArray *mappedObjectArray = [serializer unserializeValue:data];

    XCTAssertEqual([mappedObjectArray count], 1);

    [self assertMappedObject:mappedObjectArray[0]];
}

- (void)testMemoryCache
{
    id <PNYCache> targetCache = mockProtocol(@protocol(PNYCache));

    [given([targetCache cachedValueForKey:@"someKey"]) willReturn:@"someValue"];

    PNYCacheMemory *memoryCache = [[PNYCacheMemory alloc] initWithTargetCache:targetCache];

    // Check if target cache is accessed.

    XCTAssertEqualObjects([memoryCache cachedValueForKey:@"someKey"], @"someValue");

    [verify(targetCache) cachedValueForKey:@"someKey"];

    // Check if target cache is not accessed again, since the value is in memory.

    XCTAssertEqualObjects([memoryCache cachedValueForKey:@"someKey"], @"someValue");

    [verifyCount(targetCache, times(1)) cachedValueForKey:@"someKey"];

    // Check if particular value is removed.

    [memoryCache cacheValue:@"otherValue" forKey:@"otherKey"];

    XCTAssertNotNil([memoryCache cachedValueForKey:@"otherKey"]);

    [memoryCache removeCachedValueForKey:@"otherKey"];

    XCTAssertNil([memoryCache cachedValueForKey:@"otherKey"]);
    XCTAssertNotNil([memoryCache cachedValueForKey:@"someKey"]);

    // Check if all values are removed.

    [memoryCache removeAllCachedValues];

    [given([targetCache cachedValueForKey:@"someKey"]) willReturn:nil];

    XCTAssertNil([memoryCache cachedValueForKey:@"someKey"]);
}

- (void)testCache
{
    PNYCacheSerializerString *serializer = [PNYCacheSerializerString new];

    PNYCacheImpl *cache = [[PNYCacheImpl alloc] initWithFolderPath:[PNYFileUtils filePathInDocuments:@"PNYCacheTests"]
                                                        serializer:serializer];

    [cache cacheValue:@"someValue" forKey:@"someKey"];

    XCTAssertEqualObjects([cache cachedValueForKey:@"someKey"], @"someValue");

    [cache cacheValue:@"otherValue" forKey:@"otherKey"];

    [cache removeCachedValueForKey:@"otherKey"];

    XCTAssertNil([cache cachedValueForKey:@"otherKey"]);
    XCTAssertEqualObjects([cache cachedValueForKey:@"someKey"], @"someValue");

    [cache removeAllCachedValues];

    XCTAssertNil([cache cachedValueForKey:@"someKey"]);
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
    XCTAssertEqualObjects(aMappedObject.property1, @"test1");
    XCTAssertEqualObjects(aMappedObject.property2, @"test2");
}

@end