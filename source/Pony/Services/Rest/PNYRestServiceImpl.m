//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <EasyMapping/EKSerializer.h>
#import "PNYRestServiceImpl.h"
#import "PNYUserSettingsKeys.h"
#import "PNYMacros.h"
#import "PNYRestRequestOperation.h"
#import "PNYRestResponseSerializer.h"
#import "PNYResponseDto.h"
#import "PNYErrorDto.h"
#import "PNYRestTokens.h"
#import "PNYUrlUtils.h"

@implementation PNYRestServiceImpl
{
@private
    NSOperationQueue *operationQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {

        operationQueue = [[NSOperationQueue alloc] init];

        self.maxConcurrentRequestCount = 5;
    }
    return self;
}

#pragma mark - Public

- (NSInteger)maxConcurrentRequestCount
{
    return operationQueue.maxConcurrentOperationCount;
}

- (void)setMaxConcurrentRequestCount:(NSInteger)aMaxConcurrentRequestCount
{
    operationQueue.maxConcurrentOperationCount = aMaxConcurrentRequestCount;
}

#pragma mark - <PNYRestService>

- (id <PNYRestRequest>)getInstallationWithSuccess:(void (^)(PNYInstallationDto *aInstallation))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
{
    AFHTTPRequestOperation *operation = [self buildRequestOperationWithUrl:@"/api/installation"
                                                                parameters:nil headers:nil
                                                         responseDataClass:[PNYInstallationDto class]
                                                                   success:aSuccess failure:aFailure];

    [operationQueue addOperation:operation];

    return [PNYRestRequestOperation requestWithOperation:operation];
}


- (id <PNYRestRequest>)authenticate:(PNYCredentialsDto *)aCredentials
                            success:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                            failure:(PNYRestServiceFailureBlock)aFailure
{
    AFHTTPRequestOperation *operation = [self buildRequestOperationWithUrl:@"/api/authenticate"
                                                                parameters:[EKSerializer serializeObject:aCredentials withMapping:[PNYCredentialsDto objectMapping]]
                                                                   headers:nil
                                                         responseDataClass:[PNYAuthenticationDto class]
                                                                   success:aSuccess failure:aFailure];

    [operationQueue addOperation:operation];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)logoutWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                 failure:(PNYRestServiceFailureBlock)aFailure
{
    AFHTTPRequestOperation *operation = [self buildRequestOperationWithUrl:@"/api/logout"
                                                                parameters:nil headers:nil
                                                         responseDataClass:[PNYUserDto class]
                                                                   success:aSuccess failure:aFailure];

    [operationQueue addOperation:operation];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)getCurrentUserWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
{
    AFHTTPRequestOperation *operation = [self buildRequestOperationWithUrl:@"/api/currentUser"
                                                                parameters:nil headers:nil
                                                         responseDataClass:[PNYUserDto class]
                                                                   success:aSuccess failure:aFailure];

    [operationQueue addOperation:operation];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)refreshWithSuccess:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                                  failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.tokenPairDao != nil);

    NSString *refreshToken = [self.tokenPairDao fetchTokenPair].refreshToken;
    if (refreshToken == nil) {
        refreshToken = @"";
    }

    AFHTTPRequestOperation *operation = [self buildRequestOperationWithUrl:@"/api/refreshToken"
                                                                parameters:nil headers:@{PNYRestRefreshTokenHeader : refreshToken}
                                                         responseDataClass:[PNYAuthenticationDto class]
                                                                   success:aSuccess failure:aFailure];

    [operationQueue addOperation:operation];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)getArtistsWithSuccess:(void (^)(NSArray *aArtists))aSuccess
                                     failure:(PNYRestServiceFailureBlock)aFailure
{
    AFHTTPRequestOperation *operation = [self buildRequestOperationWithUrl:@"/api/artists"
                                                                parameters:nil headers:nil
                                                         responseDataClass:[PNYUserDto class]
                                                                   success:aSuccess failure:aFailure];

    [operationQueue addOperation:operation];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)getArtistAlbums:(NSString *)aArtistIdOrName
                               success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                               failure:(PNYRestServiceFailureBlock)aFailure
{
    NSString *url = [NSString stringWithFormat:@"/artistAlbums/%@", [PNYUrlUtils urlEncode:aArtistIdOrName]];

    AFHTTPRequestOperation *operation = [self buildRequestOperationWithUrl:url
                                                                parameters:nil headers:nil
                                                         responseDataClass:[PNYArtistAlbumsDto class]
                                                                   success:aSuccess failure:aFailure];

    [operationQueue addOperation:operation];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

#pragma mark - Private

- (AFHTTPRequestOperation *)buildRequestOperationWithUrl:(NSString *)aRelativeUrl
                                              parameters:(id)aParameters headers:(NSDictionary *)aHeaders
                                       responseDataClass:(Class)aResponseDataClass
                                                 success:(void (^)(id))aSuccess
                                                 failure:(PNYRestServiceFailureBlock)aFailure
{
    NSURLRequest *urlRequest = [self buildJsonRequestWithUrl:aRelativeUrl parameters:aParameters headers:aHeaders];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];

    operation.responseSerializer = [PNYRestResponseSerializer serializerWithDataClass:aResponseDataClass];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *aOperation, PNYResponseDto *aResponse) {
        if (aResponse.successful) {
            aSuccess(aResponse.data);
        } else {
            aFailure(aResponse.errors);
        }
    } failure:^(AFHTTPRequestOperation *aOperation, NSError *aError) {
        aFailure([self errorToDtoArray:aError]);
    }];

    return operation;
}

- (NSURLRequest *)buildJsonRequestWithUrl:(NSString *)aRelativeUrl parameters:(id)aParameters headers:(NSDictionary *)aHeaders
{
    PNYAssert(self.tokenPairDao != nil);

    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];

    PNYTokenPair *tokenPair = [self.tokenPairDao fetchTokenPair];
    if (tokenPair.accessToken != nil) {
        [serializer setValue:tokenPair.accessToken forHTTPHeaderField:PNYRestAccessTokenHeader];
    }

    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    [aHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *aKey, NSString *aValue, BOOL *aStop) {
        [serializer setValue:aValue forHTTPHeaderField:aKey];
    }];

    NSError *error = nil;

    NSURLRequest *urlRequest = [serializer requestBySerializingRequest:[NSURLRequest requestWithURL:[self buildUrl:aRelativeUrl]]
                                                        withParameters:aParameters error:&error];

    if (error != nil) {
        PNYLogError(@"Could not serialize JSON request: %@.", error);
    }

    return error == nil ? urlRequest : nil;
}

- (NSURL *)buildUrl:(NSString *)aRelativeUrl
{
    PNYAssert(self.userSettings != nil);

    NSMutableString *url = [NSMutableString string];

    [url appendString:[self.userSettings settingForKey:PNYUserSettingsKeyRestProtocol]];
    [url appendString:@"://"];
    [url appendString:[self.userSettings settingForKey:PNYUserSettingsKeyRestUrl]];
    if (![url hasSuffix:@"/"] && ![aRelativeUrl hasPrefix:aRelativeUrl]) {
        [url appendString:@"/"];
    }

    [url appendString:aRelativeUrl];

    return [NSURL URLWithString:url];
}

- (NSArray *)errorToDtoArray:(NSError *)aError
{
    if ([aError.domain isEqualToString:NSURLErrorDomain] && aError.code == NSURLErrorNotConnectedToInternet) {
        return @[[PNYErrorDto errorWithCode:PNYErrorDtoCodeClientOffline
                                       text:@"Could not make server request. Are you online?"
                                  arguments:nil]];
    } else {
        return @[[PNYErrorDto errorWithCode:PNYErrorDtoCodeClientRequestFailed
                                       text:[NSString stringWithFormat:@"An error occurred when making server request: %@.", aError]
                                  arguments:@[[aError localizedDescription]]]];
    }
}

@end