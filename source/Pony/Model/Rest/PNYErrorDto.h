//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKMappingProtocol.h>

@interface PNYErrorDto : NSObject <EKMappingProtocol>

@property NSString *field;
@property NSString *code;
@property NSString *text;

@property NSArray *arguments;

+ (instancetype)errorWithCode:(NSString *)aCode text:(NSString *)aText arguments:(NSArray *)aArguments;

- (instancetype)initWithCode:(NSString *)aCode text:(NSString *)aText arguments:(NSArray *)aArguments;

@end