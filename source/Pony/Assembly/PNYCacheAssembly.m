//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <Typhoon/TyphoonConfigPostProcessor.h>
#import "PNYCacheAssembly.h"
#import "PNYFileCache.h"
#import "PNYMappingCacheSerializer.h"
#import "PNYInstallationDto.h"
#import "PNYArtistAlbumsDto.h"
#import "PNYUserDto.h"
#import "PNYImageCacheSerializer.h"

@implementation PNYCacheAssembly

#pragma mark - Public

- (PNYCacheAsync *)installationCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithAsynchronousCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self installationCache]];
        }];
    }];
}

- (PNYCacheAsync *)currentUserCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithAsynchronousCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self currentUserCache]];
        }];
    }];
}

- (PNYCacheAsync *)artistsCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithAsynchronousCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self artistsCache]];
        }];
    }];
}

- (PNYCacheAsync *)artistAlbumsCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        aDefinition.scope = TyphoonScopeLazySingleton;
        [aDefinition useInitializer:@selector(initWithAsynchronousCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self artistAlbumsCache]];
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