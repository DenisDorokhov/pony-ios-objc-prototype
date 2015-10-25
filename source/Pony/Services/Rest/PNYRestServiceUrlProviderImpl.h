//
// Created by Denis Dorokhov on 25/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYRestServiceUrlProvider.h"
#import "PNYUserSettings.h"

@interface PNYRestServiceUrlProviderImpl : NSObject <PNYRestServiceUrlProvider>

@property (nonatomic, strong) id <PNYUserSettings> userSettings;

@end