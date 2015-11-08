//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "TyphoonAssembly.h"
#import "PNYServiceAssembly.h"

@interface PNYAppAssembly : TyphoonAssembly

@property (nonatomic, strong) PNYServiceAssembly *serviceAssembly;

@end