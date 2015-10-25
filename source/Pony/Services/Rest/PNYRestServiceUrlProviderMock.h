//
// Created by Denis Dorokhov on 25/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceUrlProvider.h"

@interface PNYRestServiceUrlProviderMock : NSObject <PNYRestServiceUrlProvider>

@property (nonatomic, strong) NSString *urlToReturn;

+ (instancetype)serviceUrlProviderWithUrlToReturn:(NSString *)aUrlToReturn;

- (instancetype)initWithUrlToReturn:(NSString *)aUrlToReturn;

@end