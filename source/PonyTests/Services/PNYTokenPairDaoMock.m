//
// Created by Denis Dorokhov on 31/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYTokenPairDaoMock.h"

@implementation PNYTokenPairDaoMock
{
@private
    PNYTokenPair *tokenPair;
}

#pragma mark - <PNYTokenPairDao>

- (PNYTokenPair *)fetchTokenPair
{
    return tokenPair;
}

- (void)storeTokenPair:(PNYTokenPair *)aTokenPair
{
    tokenPair = aTokenPair;
}

- (void)removeTokenPair
{
    tokenPair = nil;
}

@end