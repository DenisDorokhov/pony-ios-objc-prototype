//
// Created by Denis Dorokhov on 10/12/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface PNYErrorService : NSObject

- (void)reportErrors:(NSArray *)aErrors;
- (void)reportErrors:(NSArray *)aErrors title:(NSString *)aTitle;

@end