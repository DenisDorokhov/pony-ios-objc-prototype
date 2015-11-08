//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTokenPair.h"

@protocol PNYTokenPairDao <NSObject>

- (PNYTokenPair *)fetchTokenPair;
- (void)storeTokenPair:(PNYTokenPair *)aTokenPair;
- (void)removeTokenPair;

@end