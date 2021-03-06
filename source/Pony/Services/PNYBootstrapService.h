//
// Created by Denis Dorokhov on 05/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceUrlDao.h"
#import "PNYRestServiceCached.h"
#import "PNYAuthenticationService.h"

@class PNYBootstrapService;

@protocol PNYBootstrapServiceDelegate <NSObject>

- (void)bootstrapServiceDidStartBootstrap:(PNYBootstrapService *)aBootstrapService;
- (void)bootstrapServiceDidFinishBootstrap:(PNYBootstrapService *)aBootstrapService;

- (void)bootstrapServiceDidStartBackgroundActivity:(PNYBootstrapService *)aBootstrapService;

- (void)bootstrapServiceDidRequireRestUrl:(PNYBootstrapService *)aBootstrapService;
- (void)bootstrapServiceDidRequireAuthentication:(PNYBootstrapService *)aBootstrapService;

- (void)bootstrapService:(PNYBootstrapService *)aBootstrapService didFailWithErrors:(NSArray *)aErrors;

@end

@interface PNYBootstrapService : NSObject

@property (nonatomic, strong) id <PNYRestServiceUrlDao> restServiceUrlDao;
@property (nonatomic, strong) id <PNYRestServiceCached> restService;
@property (nonatomic, strong) PNYAuthenticationService *authenticationService;

@property (nonatomic, weak) id <PNYBootstrapServiceDelegate> delegate;

- (void)bootstrap;

- (void)clearBootstrapData;

@end