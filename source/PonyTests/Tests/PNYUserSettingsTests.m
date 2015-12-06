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
    PNYUserSettingsImpl *service;

    NSString *didCallDidSetKey;
    NSString *didCallDidSetValue;
    NSString *didCallDidRemoveKey;

    BOOL didCallDidSave;
    BOOL didCallDidClear;
}

- (void)setUp
{
    [super setUp];

    service = [PNYUserSettingsImpl new];

    [service addDelegate:self];

    [self reset];
}

- (void)tearDown
{
    [service removeDelegate:self];

    [super tearDown];
}

- (void)testUserSettings
{
    [service setSetting:@"someValue" forKey:@"someKey"];
    [service save];

    assertThat(didCallDidSetKey, equalTo(@"someKey"));
    assertThat(didCallDidSetValue, equalTo(@"someValue"));
    assertThat(didCallDidRemoveKey, nilValue());
    assertThatBool(didCallDidSave, isTrue());
    assertThatBool(didCallDidClear, isFalse());

    assertThat([service settingForKey:@"someKey"], equalTo(@"someValue"));

    [self reset];

    [service removeSettingForKey:@"someKey"];

    assertThat(didCallDidSetKey, nilValue());
    assertThat(didCallDidSetValue, nilValue());
    assertThat(didCallDidRemoveKey, equalTo(@"someKey"));
    assertThatBool(didCallDidSave, isFalse());
    assertThatBool(didCallDidClear, isFalse());

    assertThat([service settingForKey:@"someKey"], nilValue());

    [service setSetting:@"someValue1" forKey:@"someKey1"];

    [self reset];

    [service clear];

    assertThat(didCallDidSetKey, nilValue());
    assertThat(didCallDidSetValue, nilValue());
    assertThat(didCallDidRemoveKey, nilValue());
    assertThatBool(didCallDidSave, isFalse());
    assertThatBool(didCallDidClear, isTrue());

    [service removeDelegate:self];

    [self reset];

    [service save];

    assertThat(didCallDidSetKey, nilValue());
    assertThat(didCallDidSetValue, nilValue());
    assertThat(didCallDidRemoveKey, nilValue());
    assertThatBool(didCallDidSave, isFalse());
    assertThatBool(didCallDidClear, isFalse());
}

#pragma mark - <PNYUserSettingsDelegate>

- (void)userSettings:(id <PNYUserSettings>)aUserSettings didSetSetting:(id)aSetting forKey:(NSString *)aKey
{
    assertThat(aUserSettings, notNilValue());

    didCallDidSetKey = aKey;
    didCallDidSetValue = aSetting;
}

- (void)userSettings:(id <PNYUserSettings>)aUserSettings didRemoveSettingForKey:(NSString *)aKey
{
    assertThat(aUserSettings, notNilValue());

    didCallDidRemoveKey = aKey;
}

- (void)userSettingsDidSave:(id <PNYUserSettings>)aUserSettings
{
    assertThat(aUserSettings, notNilValue());

    didCallDidSave = YES;
}

- (void)userSettingsDidClear:(id <PNYUserSettings>)aUserSettings
{
    assertThat(aUserSettings, notNilValue());

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