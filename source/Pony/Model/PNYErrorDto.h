//
// Created by Denis Dorokhov on 24/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface PNYErrorDto : NSObject

@property NSString *field;
@property NSString *code;
@property NSString *text;

@property NSArray *arguments;

@end