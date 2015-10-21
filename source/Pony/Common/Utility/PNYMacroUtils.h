//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#define PNYAssert(expression) NSAssert(expression, @"" #expression)
#define PNYLocalize(key, ...) [NSString stringWithFormat:NSLocalizedString(key, nil), ##__VA_ARGS__]