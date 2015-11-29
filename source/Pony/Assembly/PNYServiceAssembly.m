//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYServiceAssembly.h"
#import "PNYRestServiceImpl.h"
#import "PNYTokenPairDaoImpl.h"
#import "PNYRestServiceCachedImpl.h"
#import "PNYRestServiceUrlDaoImpl.h"

@implementation PNYServiceAssembly

#pragma mark - Public

- (id <PNYRestServiceUrlDao>)restServiceUrlDao
{
    return [TyphoonDefinition withClass:[PNYRestServiceUrlDaoImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition injectProperty:@selector(userSettings) with:[self.utilityAssembly userSettings]];
    }];
}

- (id <PNYRestServiceCached>)restServiceCached
{
    return [TyphoonDefinition withClass:[PNYRestServiceCachedImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithTargetService:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self restService]];
        }];
        [aDefinition injectProperty:@selector(installationCache) with:[self.cacheAssembly installationCacheAsync]];
        [aDefinition injectProperty:@selector(currentUserCache) with:[self.cacheAssembly currentUserCacheAsync]];
        [aDefinition injectProperty:@selector(artistsCache) with:[self.cacheAssembly artistsCacheAsync]];
        [aDefinition injectProperty:@selector(artistAlbumsCache) with:[self.cacheAssembly artistAlbumsCacheAsync]];
        [aDefinition injectProperty:@selector(imageCache) with:[self.cacheAssembly imageCacheAsync]];
    }];
}

- (PNYBootstrapService *)bootstrapService
{
    return [TyphoonDefinition withClass:[PNYBootstrapService class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition injectProperty:@selector(restServiceUrlDao) with:[self restServiceUrlDao]];
        [aDefinition injectProperty:@selector(restService) with:[self restServiceCached]];
        [aDefinition injectProperty:@selector(authenticationService) with:[self authenticationService]];
    }];
}

- (PNYAuthenticationService *)authenticationService
{
    return [TyphoonDefinition withClass:[PNYAuthenticationService class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition injectProperty:@selector(tokenPairDao) with:[self tokenPairDao]];
        [aDefinition injectProperty:@selector(restService) with:[self restServiceCached]];
    }];
}

#pragma mark - Private

- (id <PNYRestService>)restService
{
    return [TyphoonDefinition withClass:[PNYRestServiceImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition injectProperty:@selector(urlDao) with:[self restServiceUrlDao]];
        [aDefinition injectProperty:@selector(tokenPairDao) with:[self tokenPairDao]];
    }];
}

- (id <PNYTokenPairDao>)tokenPairDao
{
    return [TyphoonDefinition withClass:[PNYTokenPairDaoImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithPersistentDictionary:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self.utilityAssembly securedPersistentDictionary]];
        }];
    }];
}

@end