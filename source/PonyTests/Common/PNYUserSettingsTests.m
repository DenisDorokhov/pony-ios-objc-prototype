//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTestCase.h"
#import "PNYUserSettings.h"
#import "PNYUserSettingsImpl.h"

@interface PNYUserSettingsTests : PNYTestCase <PNYUserSettingsDelegate>

@end

@implementation PNYUserSettingsTests
{
@private
    NSString *didCallDidSetKey;
    NSString *didCallDidSetValue;
    NSString *didCallDidRemoveKey;

    BOOL didCallDidSave;
    BOOL didCallDidClear;
}

- (void)testUserSettings
{
    PNYUserSettingsImpl *service = [[PNYUserSettingsImpl alloc] init];

    [service addDelegate:self];

    [self reset];

    [service setSetting:@"someValue" forKey:@"someKey"];
    [service save];

    XCTAssertEqualObjects(didCallDidSetKey, @"someKey");
    XCTAssertEqualObjects(didCallDidSetValue, @"someValue");
    XCTAssertNil(didCallDidRemoveKey);
    XCTAssertTrue(didCallDidSave);
    XCTAssertFalse(didCallDidClear);

    XCTAssertEqualObjects([service settingForKey:@"someKey"], @"someValue");

    [self reset];

    [service removeSettingForKey:@"someKey"];

    XCTAssertNil(didCallDidSetKey);
    XCTAssertNil(didCallDidSetValue);
    XCTAssertEqualObjects(didCallDidRemoveKey, @"someKey");
    XCTAssertFalse(didCallDidSave);
    XCTAssertFalse(didCallDidClear);

    [service setSetting:@"someValue1" forKey:@"someKey1"];

    [self reset];

    [service clear];

    XCTAssertNil(didCallDidSetKey);
    XCTAssertNil(didCallDidSetValue);
    XCTAssertNil(didCallDidRemoveKey);
    XCTAssertFalse(didCallDidSave);
    XCTAssertTrue(didCallDidClear);

    [service removeDelegate:self];

    [self reset];

    [service save];

    XCTAssertNil(didCallDidSetKey);
    XCTAssertNil(didCallDidSetValue);
    XCTAssertNil(didCallDidRemoveKey);
    XCTAssertFalse(didCallDidSave);
    XCTAssertFalse(didCallDidClear);
}

#pragma mark - <PNYUserSettingsDelegate>

- (void)userSettings:(id <PNYUserSettings>)aUserSettings didSetSetting:(id)aSetting forKey:(NSString *)aKey
{
    XCTAssertNotNil(aUserSettings);

    didCallDidSetKey = aKey;
    didCallDidSetValue = aSetting;
}

- (void)userSettings:(id <PNYUserSettings>)aUserSettings didRemoveSettingForKey:(NSString *)aKey
{
    XCTAssertNotNil(aUserSettings);

    didCallDidRemoveKey = aKey;
}

- (void)userSettingsDidSave:(id <PNYUserSettings>)aUserSettings
{
    XCTAssertNotNil(aUserSettings);

    didCallDidSave = YES;
}

- (void)userSettingsDidClear:(id <PNYUserSettings>)aUserSettings
{
    XCTAssertNotNil(aUserSettings);

    didCallDidClear = YES;
}

#pragma mark - Private

- (void)reset
{
    didCallDidSetKey = nil;
    didCallDidSetValue = nil;
    didCallDidRemoveKey = nil;

    didCallDidSave = NO;
    didCallDidClear = NO;
}

@end