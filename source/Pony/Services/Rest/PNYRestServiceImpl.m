//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <EasyMapping/EKSerializer.h>
#import "PNYRestServiceImpl.h"
#import "PNYRestRequestOperation.h"
#import "PNYRestResponseSerializer.h"
#import "PNYResponseDto.h"
#import "PNYErrorDto.h"
#import "PNYRestTokens.h"
#import "NSURLRequest+PNYDump.h"
#import "PNYMacros.h"
#import "PNYSongDto.h"

@implementation PNYRestServiceImpl
{
@private

    AFJSONRequestSerializer *requestSerializer;

    NSOperationQueue *restOperationQueue;
    NSOperationQueue *imageOperationQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self != nil) {

        requestSerializer = [AFJSONRequestSerializer new];

        restOperationQueue = [NSOperationQueue new];
        imageOperationQueue = [NSOperationQueue new];

        self.maxConcurrentRestRequestCount = 5;
        self.maxConcurrentImageRequestCount = 5;
    }
    return self;
}

#pragma mark - Public

- (NSInteger)maxConcurrentRestRequestCount
{
    return restOperationQueue.maxConcurrentOperationCount;
}

- (void)setMaxConcurrentRestRequestCount:(NSInteger)aMaxConcurrentRestRequestCount
{
    restOperationQueue.maxConcurrentOperationCount = aMaxConcurrentRestRequestCount;
}

- (NSInteger)maxConcurrentImageRequestCount
{
    return imageOperationQueue.maxConcurrentOperationCount;
}

- (void)setMaxConcurrentImageRequestCount:(NSInteger)aMaxConcurrentImageRequestCount
{
    imageOperationQueue.maxConcurrentOperationCount = aMaxConcurrentImageRequestCount;
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


- (id <PNYRestRequest>)authenticateWithCredentials:(PNYCredentialsDto *)aCredentials
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

- (id <PNYRestRequest>)getArtistAlbumsWithArtist:(NSString *)aArtistIdOrName
                                         success:(void (^)(PNYArtistAlbumsDto *aArtistAlbums))aSuccess
                                         failure:(PNYRestServiceFailureBlock)aFailure
{
    NSString *url = [NSString stringWithFormat:@"/api/artistAlbums/%@", aArtistIdOrName];

    AFHTTPRequestOperation *operation = [self runOperationWithUrl:url method:@"GET"
                                                responseDataClass:[PNYArtistAlbumsDto class]
                                                          success:aSuccess failure:aFailure];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)getSongsWithIds:(NSArray *)aSongIds success:(void (^)(NSArray *aSongs))aSuccess failure:(PNYRestServiceFailureBlock)aFailure
{
    AFHTTPRequestOperation *operation = [self runOperationWithUrl:@"/api/getSongs" method:@"POST"
                                                       parameters:aSongIds
                                                responseDataClass:[PNYSongDto class]
                                                          success:aSuccess failure:aFailure];

    return [PNYRestRequestOperation requestWithOperation:operation];
}

- (id <PNYRestRequest>)getImage:(NSString *)aAbsoluteUrl
                        success:(void (^)(UIImage *aImage))aSuccess
                        failure:(PNYRestServiceFailureBlock)aFailure
{
    NSError *error = nil;

    NSURLRequest *urlRequest = [self buildRequestWithAbsoluteUrl:aAbsoluteUrl method:@"GET"
                                                         headers:nil parameters:nil error:&error];

    if (error == nil) {

        PNYLogVerbose(@"Running image request: %@.", [urlRequest dump]);

        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];

        operation.responseSerializer = [AFImageResponseSerializer serializer];

        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *aOperation, UIImage *aImage) {
            if (aSuccess != nil) {
                aSuccess(aImage);
            }
        }                                failure:^(AFHTTPRequestOperation *aOperation, NSError *aError) {
            if (aFailure != nil) {
                aFailure([self errorToDtoArray:aError]);
            }
        }];

        [imageOperationQueue addOperation:operation];

        return [PNYRestRequestOperation requestWithOperation:operation];

    } else {
        if (aFailure != nil) {
            aFailure([self errorToDtoArray:error]);
        }
    }

    return nil;
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

    NSURLRequest *urlRequest = [self buildRequestWithRelativeUrl:aRelativeUrl method:aMethod
                                                         headers:aHeaders parameters:aParameters error:&error];

    if (error == nil) {

        PNYLogVerbose(@"Running REST request: %@.", [urlRequest dump]);

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
        }                                failure:^(AFHTTPRequestOperation *aOperation, NSError *aError) {
            if (aFailure != nil) {
                aFailure([self errorToDtoArray:aError]);
            }
        }];

        [restOperationQueue addOperation:operation];

        return operation;

    } else {
        if (aFailure != nil) {
            aFailure([self errorToDtoArray:error]);
        }
    }

    return nil;
}

- (NSURLRequest *)buildRequestWithRelativeUrl:(NSString *)aRelativeUrl method:(NSString *)aMethod
                                      headers:(NSDictionary *)aHeaders parameters:(id)aParameters
                                        error:(NSError **)aError
{
    return [self buildRequestWithAbsoluteUrl:[self buildUrl:aRelativeUrl] method:aMethod headers:aHeaders parameters:aParameters error:aError];
}

- (NSURLRequest *)buildRequestWithAbsoluteUrl:(NSString *)aAbsoluteUrl method:(NSString *)aMethod
                                      headers:(NSDictionary *)aHeaders parameters:(id)aParameters
                                        error:(NSError **)aError
{
    PNYAssert(self.tokenPairDao != nil);

    NSMutableURLRequest *urlRequest = [requestSerializer requestWithMethod:aMethod URLString:aAbsoluteUrl
                                                                parameters:aParameters error:aError];

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

- (NSString *)buildUrl:(NSString *)aRelativeUrl
{
    PNYAssert(self.urlDao != nil);

    return [[[self.urlDao fetchUrl] URLByAppendingPathComponent:aRelativeUrl] absoluteString];
}

- (NSArray *)errorToDtoArray:(NSError *)aError
{
    if ([aError.domain isEqualToString:NSURLErrorDomain]) {
        if (aError.code == NSURLErrorNotConnectedToInternet) {
            return @[[PNYErrorDtoFactory createErrorClientOffline]];
        } else if (aError.code == NSURLErrorCancelled) {
            return @[[PNYErrorDtoFactory createErrorClientRequestCancelled]];
        }
    }

    return @[[PNYErrorDto errorWithCode:PNYErrorDtoCodeClientRequestFailed
                                   text:[NSString stringWithFormat:@"An error occurred when making server request: %@.", aError]
                              arguments:@[[aError localizedDescription]]]];
}

@end