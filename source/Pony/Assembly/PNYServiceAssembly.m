//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYServiceAssembly.h"
#import "PNYPlistConfigFactory.h"
#import "PNYRestServiceUrlProvider.h"
#import "PNYUserSettingsImpl.h"
#import "PNYRestServiceUrlProviderImpl.h"
#import "PNYRestServiceImpl.h"
#import "PNYPersistentDictionary.h"
#import "PNYKeychainDictionary.h"
#import "PNYTokenPairDaoImpl.h"
#import "PNYRestServiceCachedImpl.h"

@implementation PNYServiceAssembly

#pragma mark - Public

- (id <PNYConfig>)config
{
    return [TyphoonDefinition withFactory:[self plistConfigFactory]
                                 selector:@selector(configWithPlistPaths:)
                               parameters:^(TyphoonMethod *aFactoryMethod) {
                                   [aFactoryMethod injectParameterWith:@[
                                           [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"]
                                   ]];
                               }];
}

- (PNYEventBus *)eventBus
{
    return [TyphoonDefinition withClass:[PNYEventBus class]];
}

- (id <PNYUserSettings>)userSettings
{
    return [TyphoonDefinition withClass:[PNYUserSettingsImpl class]];
}

- (id <PNYRestServiceCached>)restServiceCached
{
    return [TyphoonDefinition withClass:[PNYRestServiceCachedImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(initWithTargetService:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self restService]];
        }];
        [aDefinition injectProperty:@selector(installationCache) with:[self.cacheAssembly installationCacheAsync]];
        [aDefinition injectProperty:@selector(currentUserCache) with:[self.cacheAssembly currentUserCacheAsync]];
        [aDefinition injectProperty:@selector(artistsCache) with:[self.cacheAssembly artistsCacheAsync]];
        [aDefinition injectProperty:@selector(artistAlbumsCache) with:[self.cacheAssembly artistAlbumsCacheAsync]];
    }];
}

- (PNYBootstrapService *)bootstrapService
{
    return [TyphoonDefinition withClass:[PNYBootstrapService class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(userSettings) with:[self userSettings]];
        [aDefinition injectProperty:@selector(authenticationService) with:[self authenticationService]];
    }];
}

- (PNYAuthenticationService *)authenticationService
{
    return [TyphoonDefinition withClass:[PNYAuthenticationService class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(tokenPairDao) with:[self tokenPairDao]];
        [aDefinition injectProperty:@selector(restService) with:[self restServiceCached]];
    }];
}

#pragma mark - Private

- (id <PNYRestService>)restService
{
    return [TyphoonDefinition withClass:[PNYRestServiceImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(urlProvider) with:[self restServiceUrlProvider]];
        [aDefinition injectProperty:@selector(tokenPairDao) with:[self tokenPairDao]];
    }];
}

- (id <PNYTokenPairDao>)tokenPairDao
{
    return [TyphoonDefinition withClass:[PNYTokenPairDaoImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(initWithPersistentDictionary:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self keychainDictionary]];
        }];
    }];
}

- (id <PNYRestServiceUrlProvider>)restServiceUrlProvider
{
    return [TyphoonDefinition withClass:[PNYRestServiceUrlProviderImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(userSettings) with:[self userSettings]];
    }];
}

- (id <PNYPersistentDictionary>)keychainDictionary
{
    return [TyphoonDefinition withClass:[PNYKeychainDictionary class]];
}

- (PNYPlistConfigFactory *)plistConfigFactory
{
    return [TyphoonDefinition withClass:[PNYPlistConfigFactory class]];
}

@end