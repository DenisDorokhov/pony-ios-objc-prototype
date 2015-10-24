//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import <EasyMapping/EKMappingProtocol.h>

@interface PNYAbstractDto : NSObject <EKMappingProtocol>

@property (nonatomic, strong) NSNumber *id;

@end