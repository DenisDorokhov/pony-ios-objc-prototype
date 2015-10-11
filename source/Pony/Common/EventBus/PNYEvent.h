//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface PNYEvent : NSObject

@property (nonatomic, readonly) NSString *type;

@property (nonatomic, readonly) BOOL cancelled;

@property (nonatomic, strong) id userData;

+ (instancetype)eventWithType:(NSString *)aType;
+ (instancetype)eventWithType:(NSString *)aType userData:(id)aUserData;

- (instancetype)initWithType:(NSString *)aType;
- (instancetype)initWithType:(NSString *)aType userData:(id)aUserData;

- (void)cancel;

@end