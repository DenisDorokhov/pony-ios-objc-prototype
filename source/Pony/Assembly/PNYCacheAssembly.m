//
// Created by Denis Dorokhov on 07/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYCacheAssembly.h"
#import "PNYCacheImpl.h"
#import "PNYFileUtils.h"
#import "PNYMappingCacheSerializer.h"
#import "PNYInstallationDto.h"

@implementation PNYCacheAssembly

#pragma mark - Public

- (PNYCacheAsync *)installationCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(initWithCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self installationCache]];
        }];
    }];
}

- (PNYCacheAsync *)currentUserCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(initWithCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self currentUserCache]];
        }];
    }];
}

- (PNYCacheAsync *)artistsCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(initWithCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self artistsCache]];
        }];
    }];
}

- (PNYCacheAsync *)artistAlbumsCacheAsync
{
    return [TyphoonDefinition withClass:[PNYCacheAsync class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(initWithCache:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[self artistAlbumsCache]];
        }];
    }];
}

- (id <PNYCache>)installationCache
{
    return [TyphoonDefinition withClass:[PNYCacheImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(initWithFolderPath:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[PNYFileUtils filePathInDocuments:@"Cache/Installation"]];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYInstallationDto class]]];
        }];
    }];
}

- (id <PNYCache>)currentUserCache
{
    return [TyphoonDefinition withClass:[PNYCacheImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(initWithFolderPath:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[PNYFileUtils filePathInDocuments:@"Cache/CurrentUser"]];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYInstallationDto class]]];
        }];
    }];
}

- (id <PNYCache>)artistsCache
{
    return [TyphoonDefinition withClass:[PNYCacheImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(initWithFolderPath:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[PNYFileUtils filePathInDocuments:@"Cache/Artists"]];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYInstallationDto class]]];
        }];
    }];
}

- (id <PNYCache>)artistAlbumsCache
{
    return [TyphoonDefinition withClass:[PNYCacheImpl class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(initWithFolderPath:serializer:) parameters:^(TyphoonMethod *aInitializer) {
            [aInitializer injectParameterWith:[PNYFileUtils filePathInDocuments:@"Cache/ArtistAlbums"]];
            [aInitializer injectParameterWith:[PNYMappingCacheSerializer mappingCacheSerializerWithValueClass:[PNYInstallationDto class]]];
        }];
    }];
}

@end