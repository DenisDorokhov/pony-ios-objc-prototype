//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYEvent.h"

@interface PNYEventBus : NSObject

- (void)addListener:(NSString *)aType object:(id)aObject selector:(SEL)aSelector;
- (void)removeListener:(NSString *)aType object:(id)aObject selector:(SEL)aSelector;
- (void)removeListenersWithObject:(id)aObject;

- (void)fireEvent:(PNYEvent *)aEvent;

@end