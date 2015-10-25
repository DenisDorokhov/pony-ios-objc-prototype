//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKObjectMapping.h>

@interface PNYResponseDto : NSObject

@property (nonatomic, strong) NSString *version;

@property (nonatomic) BOOL successful;

@property (nonatomic, strong) NSArray *errors;

@property (nonatomic, strong) id data;

+ (EKObjectMapping *)objectMappingWithDataClass:(Class)aDataClass;

@end