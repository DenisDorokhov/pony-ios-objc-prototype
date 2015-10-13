//
// Created by Denis Dorokhov on 13/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface PNYRandomUtils : NSObject

+ (int)randomIntFrom:(int)aFrom to:(int)aTo;
+ (float)randomFloatFrom:(float)aFrom to:(float)aTo;

+ (BOOL)randomBool;
+ (BOOL)boolWithProbability:(uint)aProbability;

+ (id)randomArrayElement:(NSArray *)aArray;
+ (NSMutableArray *) shuffleArray:(NSArray *)aArray;

+ (NSString *)uuid;

@end