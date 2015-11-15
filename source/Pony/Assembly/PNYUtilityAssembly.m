//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYUtilityAssembly.h"
#import "PNYLogFormatter.h"
#import "PNYPlistConfigFactory.h"
#import "PNYEventBusImpl.h"
#import "PNYUserSettingsImpl.h"
#import "PNYKeychainDictionary.h"
#import <Typhoon/TyphoonFactoryDefinition.h>
#import <Typhoon/TyphoonDefinition+Infrastructure.h>
#import <CocoaLumberjack/DDTTYLogger.h>

#ifdef DEBUG
NSUInteger ddLogLevel = DDLogLevelDebug;
#else
NSUInteger ddLogLevel = DDLogLevelOff;
#endif

@implementation PNYUtilityAssembly

#pragma mark - Public

- (id <PNYConfig>)config
{
    return [TyphoonDefinition withFactory:[self plistConfigFactory]
                                 selector:@selector(configWithPlistPaths:)
                               parameters:^(TyphoonMethod *aFactoryMethod) {
                                   [aFactoryMethod injectParameterWith:@[
                                           [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]
                                   ]];
                               }
                            configuration:^(TyphoonFactoryDefinition *aDefinition) {
                                aDefinition.scope = TyphoonScopeLazySingleton;
                            }];
}

- (id <PNYEventBus>)eventBus
{
    return [TyphoonDefinition withClass:[PNYEventBusImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
    }];
}

- (id <PNYUserSettings>)userSettings
{
    return [TyphoonDefinition withClass:[PNYUserSettingsImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
    }];
}

- (id <PNYPersistentDictionary>)securedPersistentDictionary
{
    return [TyphoonDefinition withClass:[PNYKeychainDictionary class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
    }];
}

#pragma mark - Private

- (id)configPostProcessor
{
    return [TyphoonDefinition configDefinitionWithName:@"Config.plist"];
}

- (id)logging
{
    return [TyphoonDefinition withClass:[DDLog class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
        [definition useInitializer:@selector(class)];
        [definition injectMethod:@selector(addLogger:) parameters:^(TyphoonMethod *aMethod) {
            [aMethod injectParameterWith:[self ttyLogger]];
        }];
    }];
}

- (id <DDLogger>)ttyLogger
{
    return [TyphoonDefinition withClass:[DDTTYLogger class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(sharedInstance)];
        [aDefinition injectProperty:@selector(logFormatter) with:[self logFormatter]];
    }];
}

- (id <DDLogFormatter>)logFormatter
{
    return [TyphoonDefinition withClass:[PNYLogFormatter class]];
}

- (PNYPlistConfigFactory *)plistConfigFactory
{
    return [TyphoonDefinition withClass:[PNYPlistConfigFactory class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
    }];
}

@end