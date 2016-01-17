//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYAppAssembly.h"
#import "PNYAppDelegate.h"
#import "PNYBootstrapController.h"
#import "PNYBootstrapLoginConfigController.h"
#import "PNYBootstrapServerConfigController.h"
#import "PNYArtistsController.h"
#import "PNYAlbumsController.h"
#import "PNYDownloadManagerController.h"
#import "PNYSongDownloadCell.h"
#import "PNYSongCell.h"
#import "PNYSongCellWithDiscNumber.h"
#import "PNYAlbumHeader.h"

@implementation PNYAppAssembly

#pragma mark - Private

- (PNYAppDelegate *)appDelegate
{
    return [TyphoonDefinition withClass:[PNYAppDelegate class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(config) with:[self.utilityAssembly config]];
    }];
}

- (PNYBootstrapController *)bootstrapController
{
    return [TyphoonDefinition withClass:[PNYBootstrapController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(bootstrapService) with:[self.serviceAssembly bootstrapService]];
    }];
}

- (PNYBootstrapServerConfigController *)bootstrapServerController
{
    return [TyphoonDefinition withClass:[PNYBootstrapServerConfigController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(restServiceUrlDao) with:[self.serviceAssembly restServiceUrlDao]];
        [aDefinition injectProperty:@selector(restService) with:[self.serviceAssembly restServiceCached]];
    }];
}

- (PNYBootstrapLoginConfigController *)bootstrapAuthenticationController
{
    return [TyphoonDefinition withClass:[PNYBootstrapLoginConfigController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(authenticationService) with:[self.serviceAssembly authenticationService]];
    }];
}

- (PNYArtistsController *)artistsController
{
    return [TyphoonDefinition withClass:[PNYArtistsController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(restService) with:[self.serviceAssembly restServiceCached]];
        [aDefinition injectProperty:@selector(authenticationService) with:[self.serviceAssembly authenticationService]];
        [aDefinition injectProperty:@selector(errorService) with:[self.serviceAssembly errorService]];
    }];
}

- (PNYAlbumsController *)albumsController
{
    return [TyphoonDefinition withClass:[PNYAlbumsController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(appAssembly) with:self];
        [aDefinition injectProperty:@selector(restService) with:[self.serviceAssembly restServiceCached]];
        [aDefinition injectProperty:@selector(errorService) with:[self.serviceAssembly errorService]];
        [aDefinition injectProperty:@selector(songDownloadService) with:[self.serviceAssembly songDownloadService]];
    }];
}

- (PNYSongCell *)albumHeader
{
    return [TyphoonDefinition withClass:[PNYAlbumHeader class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(songDownloadService) with:[self.serviceAssembly songDownloadService]];
    }];
}

- (PNYSongCell *)songCell
{
    return [TyphoonDefinition withClass:[PNYSongCell class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(songDownloadService) with:[self.serviceAssembly songDownloadService]];
    }];
}

- (PNYSongCellWithDiscNumber *)songCellWithDiscNumber
{
    return [TyphoonDefinition withClass:[PNYSongCellWithDiscNumber class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(songDownloadService) with:[self.serviceAssembly songDownloadService]];
    }];
}

- (PNYDownloadManagerController *)downloadManagerController
{
    return [TyphoonDefinition withClass:[PNYDownloadManagerController class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(appAssembly) with:self];
        [aDefinition injectProperty:@selector(songDownloadService) with:[self.serviceAssembly songDownloadService]];
    }];
}

- (PNYSongDownloadCell *)songDownloadCell
{
    return [TyphoonDefinition withClass:[PNYSongDownloadCell class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition injectProperty:@selector(songDownloadService) with:[self.serviceAssembly songDownloadService]];
    }];
}

@end