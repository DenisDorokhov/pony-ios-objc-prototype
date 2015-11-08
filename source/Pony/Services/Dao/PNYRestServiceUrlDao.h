//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@protocol PNYRestServiceUrlDao <NSObject>

- (NSURL *)fetchUrl;
- (void)storeUrl:(NSURL *)aServiceUrl;
- (void)removeUrl;

@end