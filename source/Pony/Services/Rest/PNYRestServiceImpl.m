//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <EasyMapping/EKSerializer.h>
#import "PNYRestServiceImpl.h"
#import "PNYMacros.h"
#import "PNYRestRequestOperation.h"
#import "PNYRestResponseSerializer.h"
#import "PNYResponseDto.h"
#import "PNYErrorDto.h"
#import "PNYRestTokens.h"

@implementation PNYRestServiceImpl
{
@private
    NSOperationQueue *operationQueue;
    AFJSONRequestSerializer *requestSerializer;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {

        operationQueue = [[NSOperationQueue alloc] init];
        requestSerializer = [[AFJSONRequestSerializer alloc] init];

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
    AFHTTPRequestOperation *operation = [self runOperationWithUrl:@"/api/installation" method:@"GET"
                                                responseDataClass:[PNYInstallationDto class]
                                                          success:aSuccess failure:aFailure];

    return [PNYRestRequestOperation requestWithOperation:operation];
}


- (id <PNYRestRequest>)authenticate:(PNYCredentialsDto *)aCredentials
                            success:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                            failure:(PNYRestServiceFailureBlock)aFailure
{
    NSDictionary *credentialsDictionary = [EKSerializer serializeObject:aCredentials
                                                            withMapping:[PNYCredentialsDto objectMapping]];

    AFHTTPRequestOperation *operation = [self runOperationWithUrl:@"/api/authenticate" method:@"POST"
                                                       parameters:credentialsDictionary
                                                responseDataClass:[PNYAuthenticationDto class]
                                                          success:aSuccess failure:aFailure];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)logoutWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                 failure:(PNYRestServiceFailureBlock)aFailure
{
    AFHTTPRequestOperation *operation = [self runOperationWithUrl:@"/api/logout" method:@"POST"
                                                responseDataClass:[PNYUserDto class]
                                                          success:aSuccess failure:aFailure];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)getCurrentUserWithSuccess:(void (^)(PNYUserDto *aUser))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
{
    AFHTTPRequestOperation *operation = [self runOperationWithUrl:@"/api/currentUser" method:@"GET"
                                                responseDataClass:[PNYUserDto class]
                                                          success:aSuccess failure:aFailure];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)refreshTokenWithSuccess:(void (^)(PNYAuthenticationDto *aAuthentication))aSuccess
                                       failure:(PNYRestServiceFailureBlock)aFailure
{
    PNYAssert(self.tokenPairDao != nil);

    NSString *refreshToken = [self.tokenPairDao fetchTokenPair].refreshToken;
    if (refreshToken == nil) {
        refreshToken = @"";
    }

    AFHTTPRequestOperation *operation = [self runOperationWithUrl:@"/api/refreshToken" method:@"POST"
                                                          headers:@{PNYRestRefreshTokenHeader : refreshToken}
                                                responseDataClass:[PNYAuthenticationDto class]
                                                          success:aSuccess failure:aFailure];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)getArtistsWithSuccess:(void (^)(NSArray *aArtists))aSuccess
                                     failure:(PNYRestServiceFailureBlock)aFailure
{
    AFHTTPRequestOperation *operation = [self runOperationWithUrl:@"/api/artists" method:@"GET"
                                                responseDataClass:[PNYArtistDto class]
                                                          success:aSuccess failure:aFailure];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)getArtistAlbums:(NSString *)aArtistIdOrName
                               success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                               failure:(PNYRestServiceFailureBlock)aFailure
{
    NSString *url = [NSString stringWithFormat:@"/api/artistAlbums/%@", aArtistIdOrName];

    AFHTTPRequestOperation *operation = [self runOperationWithUrl:url method:@"GET"
                                                responseDataClass:[PNYArtistAlbumsDto class]
                                                          success:aSuccess failure:aFailure];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

#pragma mark - Private

- (AFHTTPRequestOperation *)runOperationWithUrl:(NSString *)aRelativeUrl method:(NSString *)aMethod
                              responseDataClass:(Class)aResponseDataClass
                                        success:(void (^)(id))aSuccess failure:(PNYRestServiceFailureBlock)aFailure
{
    return [self runOperationWithUrl:aRelativeUrl method:aMethod
                          parameters:nil headers:nil
                   responseDataClass:aResponseDataClass
                             success:aSuccess failure:aFailure];
}

- (AFHTTPRequestOperation *)runOperationWithUrl:(NSString *)aRelativeUrl method:(NSString *)aMethod
                                     parameters:(id)aParameters
                              responseDataClass:(Class)aResponseDataClass
                                        success:(void (^)(id))aSuccess failure:(PNYRestServiceFailureBlock)aFailure
{
    return [self runOperationWithUrl:aRelativeUrl method:aMethod
                          parameters:aParameters headers:nil
                   responseDataClass:aResponseDataClass
                             success:aSuccess failure:aFailure];
}

- (AFHTTPRequestOperation *)runOperationWithUrl:(NSString *)aRelativeUrl method:(NSString *)aMethod
                                        headers:(NSDictionary *)aHeaders
                              responseDataClass:(Class)aResponseDataClass
                                        success:(void (^)(id))aSuccess failure:(PNYRestServiceFailureBlock)aFailure
{
    return [self runOperationWithUrl:aRelativeUrl method:aMethod
                          parameters:nil headers:aHeaders
                   responseDataClass:aResponseDataClass
                             success:aSuccess failure:aFailure];
}

- (AFHTTPRequestOperation *)runOperationWithUrl:(NSString *)aRelativeUrl method:(NSString *)aMethod
                                     parameters:(id)aParameters headers:(NSDictionary *)aHeaders
                              responseDataClass:(Class)aResponseDataClass
                                        success:(void (^)(id))aSuccess failure:(PNYRestServiceFailureBlock)aFailure
{
    NSError *error = nil;

    NSURLRequest *urlRequest = [self buildRequestWithUrl:aRelativeUrl method:aMethod
                                              parameters:aParameters headers:aHeaders
                                                   error:&error];

    if (error == nil) {

        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];

        operation.responseSerializer = [PNYRestResponseSerializer serializerWithDataClass:aResponseDataClass];

        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *aOperation, PNYResponseDto *aResponse) {
            if (aResponse.successful) {
                if (aSuccess != nil) {
                    aSuccess(aResponse.data);
                }
            } else {
                if (aFailure != nil) {
                    aFailure(aResponse.errors);
                }
            }
        } failure:^(AFHTTPRequestOperation *aOperation, NSError *aError) {
            if (aFailure != nil) {
                aFailure([self errorToDtoArray:aError]);
            }
        }];

        [operationQueue addOperation:operation];

        return operation;

    } else {
        if (aFailure != nil) {
            aFailure([self errorToDtoArray:error]);
        }
    }

    return nil;
}

- (NSURLRequest *)buildRequestWithUrl:(NSString *)aRelativeUrl method:(NSString *)aMethod
                           parameters:(id)aParameters headers:(NSDictionary *)aHeaders
                                error:(NSError **)aError
{
    PNYAssert(self.tokenPairDao != nil);

    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:aMethod
                                                          URLString:[[self buildUrl:aRelativeUrl] absoluteString]
                                                         parameters:aParameters
                                                              error:aError];

    if (*aError == nil) {

        PNYTokenPair *tokenPair = [self.tokenPairDao fetchTokenPair];
        if (tokenPair.accessToken != nil) {
            [urlRequest setValue:tokenPair.accessToken forHTTPHeaderField:PNYRestAccessTokenHeader];
        }

        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];

        [aHeaders enumerateKeysAndObjectsUsingBlock:^(NSString *aKey, NSString *aValue, BOOL *aStop) {
            [urlRequest setValue:aValue forHTTPHeaderField:aKey];
        }];

    } else {
        PNYLogError(@"Could not serialize JSON request: %@.", *aError);
    }

    return *aError == nil ? urlRequest : nil;
}

- (NSURL *)buildUrl:(NSString *)aRelativeUrl
{
    PNYAssert(self.urlProvider != nil);

    return [[self.urlProvider serverUrl] URLByAppendingPathComponent:aRelativeUrl];
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