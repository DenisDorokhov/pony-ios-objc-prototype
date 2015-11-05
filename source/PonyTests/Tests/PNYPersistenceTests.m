//
// Created by Denis Dorokhov on 13/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYPersistentDictionaryImpl.h"
#import "PNYKeychainDictionary.h"
#import "PNYFileUtils.h"

@interface PNYPersistenceTests : PNYTestCase

@end

@implementation PNYPersistenceTests
{
@private
    NSString *filePath;
    NSString *keychainName;
}

- (void)setUp
{
    [super setUp];

    filePath = [PNYFileUtils filePathInDocuments:@"test"];
    keychainName = @"test";
}

- (void)testPersistentDictionary
{
    [self fillAndSavePersistentDictionary:[[PNYPersistentDictionaryImpl alloc] initWithFilePath:filePath]];

    PNYPersistentDictionaryImpl *service = [[PNYPersistentDictionaryImpl alloc] initWithFilePath:filePath];

    [self assertDictionary:service.data];
}

- (void)testKeychainDictionary
{
    [self fillAndSavePersistentDictionary:[[PNYKeychainDictionary alloc] initWithName:keychainName]];

    PNYKeychainDictionary *service = [[PNYKeychainDictionary alloc] initWithName:keychainName];

    [self assertDictionary:service.data];
}

#pragma mark - Private

- (void)fillAndSavePersistentDictionary:(id <PNYPersistentDictionary>)aService
{
    assertThat(aService.data, isEmpty());

    aService.data[@"globalKey1"] = @{ @"testKey" : @"testValue" };
    aService.data[@"globalKey2"] = @"globalValue2";

    [aService save];
}

- (void)assertDictionary:(NSDictionary *)aDictionary
{
    assertThat(((NSDictionary *)aDictionary[@"globalKey1"])[@"testKey"], equalTo(@"testValue"));
    assertThat(aDictionary[@"globalKey2"], equalTo(@"globalValue2"));
}

@end