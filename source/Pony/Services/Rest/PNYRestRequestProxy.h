//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestRequest.h"

@interface PNYRestRequestProxy : NSObject <PNYRestRequest>

@property (nonatomic, strong) id <PNYRestRequest> targetRequest;

@end