//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCacheAssembly.h"
#import "PNYCacheImpl.h"
#import "PNYFileUtils.h"
#import "PNYMappingCacheSerializer.h"
#import "PNYInstallationDto.h"
#import "PNYOfflineOnlyCache.h"

@implementation PNYCacheAssembly

#pragma mark - Public

- (PNYCacheAsync *)installationCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self installationCacheOfflineOnly]];
        }];
    }];
}

- (PNYCacheAsync *)currentUserCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self currentUserCacheOfflineOnly]];
        }];
    }];
}

- (PNYCacheAsync *)artistsCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self artistsCacheOfflineOnly]];
        }];
    }];
}

- (PNYCacheAsync *)artistAlbumsCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self artistAlbumsCacheOfflineOnly]];
        }];
    }];
}

#pragma mark - Private

- (id <PNYCache>)installationCacheOfflineOnly
{
    return [TyphoonDefinition withClass:[PNYOfflineOnlyCache class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithTargetCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self installationCache]];
        }];
    }];
}

- (id <PNYCache>)currentUserCacheOfflineOnly
{
    return [TyphoonDefinition withClass:[PNYOfflineOnlyCache class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithTargetCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self currentUserCache]];
        }];
    }];
}

- (id <PNYCache>)artistsCacheOfflineOnly
{
    return [TyphoonDefinition withClass:[PNYOfflineOnlyCache class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithTargetCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self artistsCache]];
        }];
    }];
}

- (id <PNYCache>)artistAlbumsCacheOfflineOnly
{
    return [TyphoonDefinition withClass:[PNYOfflineOnlyCache class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithTargetCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self artistAlbumsCache]];
        }];
    }];
}

- (id <PNYCache>)installationCache
{
    return [TyphoonDefinition withClass:[PNYCacheImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithFolderPath:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[PNYFileUtils filePathInDocuments:@"Cache/Installation"]];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYInstallationDto class]]];
        }];
    }];
}

- (id <PNYCache>)currentUserCache
{
    return [TyphoonDefinition withClass:[PNYCacheImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithFolderPath:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[PNYFileUtils filePathInDocuments:@"Cache/CurrentUser"]];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYInstallationDto class]]];
        }];
    }];
}

- (id <PNYCache>)artistsCache
{
    return [TyphoonDefinition withClass:[PNYCacheImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithFolderPath:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[PNYFileUtils filePathInDocuments:@"Cache/Artists"]];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYInstallationDto class]]];
        }];
    }];
}

- (id <PNYCache>)artistAlbumsCache
{
    return [TyphoonDefinition withClass:[PNYCacheImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithFolderPath:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[PNYFileUtils filePathInDocuments:@"Cache/ArtistAlbums"]];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYInstallationDto class]]];
        }];
    }];
}

@end