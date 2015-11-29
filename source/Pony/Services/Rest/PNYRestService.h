//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestRequest.h"
#import "PNYCredentialsDto.h"
#import "PNYAuthenticationDto.h"
#import "PNYArtistAlbumsDto.h"
#import "PNYInstallationDto.h"

typedef void (^PNYRestServiceSuccessBlock)(id aData);

typedef void (^PNYRestServiceFailureBlock)(NSArray *aErrors);

@protocol PNYRestService <NSObject>

- (id <PNYRestRequest>)getInstallationWithSuccess:(void (^)(PNYInstallationDto *aInstallation))aSuccess
                                          failure:(PNYRestServiceFailureBlock)aFailure;

- (id <PNYRestRequest>)authenticateWithCredentials:(PNYCredentialsDto *)aCredentials
                                           success:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                                           failure:(PNYRestServiceFailureBlock)aFailure;

- (id <PNYRestRequest>)logoutWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                 failure:(PNYRestServiceFailureBlock)aFailure;

- (id <PNYRestRequest>)getCurrentUserWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure;

- (id <PNYRestRequest>)refreshTokenWithSuccess:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                                       failure:(PNYRestServiceFailureBlock)aFailure;

- (id <PNYRestRequest>)getArtistsWithSuccess:(void (^)(NSArray *aArtists))aSuccess
                                     failure:(PNYRestServiceFailureBlock)aFailure;

- (id <PNYRestRequest>)getArtistAlbumsWithArtist:(NSString *)aArtistIdOrName
                                         success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure;

- (id <PNYRestRequest>)getImage:(NSString *)aAbsoluteUrl
                        success:(void (^)(UIImage *aImage))aSuccess
                        failure:(PNYRestServiceFailureBlock)aFailure;

@end