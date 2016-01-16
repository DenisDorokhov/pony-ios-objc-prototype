//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKMappingProtocol.h>

@interface PNYTokenPair : NSObject <EKMappingProtocol>

@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSDate *accessTokenExpiration;

@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSDate *refreshTokenExpiration;

@end