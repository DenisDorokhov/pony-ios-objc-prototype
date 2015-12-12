//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <Typhoon/TyphoonConfigPostProcessor.h>
#import "PNYCacheAssembly.h"
#import "PNYFileCache.h"
#import "PNYMappingCacheSerializer.h"
#import "PNYInstallationDto.h"
#import "PNYOfflineOnlyCache.h"
#import "PNYArtistAlbumsDto.h"
#import "PNYUserDto.h"
#import "PNYImageCacheSerializer.h"
#import "PNYMemoryCache.h"

@implementation PNYCacheAssembly

#pragma mark - Public

- (PNYCacheAsync *)installationCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithAsynchronousCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self installationCacheOfflineOnly]];
        }];
    }];
}

- (PNYCacheAsync *)currentUserCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithAsynchronousCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self currentUserCacheOfflineOnly]];
        }];
    }];
}

- (PNYCacheAsync *)artistsCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithAsynchronousCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self artistsCacheOfflineOnly]];
        }];
    }];
}

- (PNYCacheAsync *)artistAlbumsCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithAsynchronousCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self artistAlbumsCacheOfflineOnly]];
        }];
    }];
}

- (PNYCacheAsync *)imageCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithAsynchronousCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self imageCache]];
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
    return [TyphoonDefinition withClass:[PNYFileCache class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithFolderPathInDocuments:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:TyphoonConfig(@"cache.installationFolder")];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYInstallationDto class]]];
        }];
    }];
}

- (id <PNYCache>)currentUserCache
{
    return [TyphoonDefinition withClass:[PNYFileCache class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithFolderPathInDocuments:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:TyphoonConfig(@"cache.currentUserFolder")];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYUserDto class]]];
        }];
    }];
}

- (id <PNYCache>)artistsCache
{
    return [TyphoonDefinition withClass:[PNYFileCache class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithFolderPathInDocuments:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:TyphoonConfig(@"cache.artistsFolder")];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYArtistDto class]]];
        }];
    }];
}

- (id <PNYCache>)artistAlbumsCache
{
    return [TyphoonDefinition withClass:[PNYFileCache class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithFolderPathInDocuments:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:TyphoonConfig(@"cache.artistAlbumsFolder")];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYArtistAlbumsDto class]]];
        }];
    }];
}

- (id <PNYCache>)imageCache
{
    return [TyphoonDefinition withClass:[PNYFileCache class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithFolderPathInDocuments:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:TyphoonConfig(@"cache.imagesFolder")];
            [aInitializer injectParameterWith:[PNYImageCacheSerializer new]];
        }];
    }];
}

@end