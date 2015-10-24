//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKMappingProtocol.h>

@interface PNYCredentialsDto : NSObject <EKMappingProtocol>

@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

@end