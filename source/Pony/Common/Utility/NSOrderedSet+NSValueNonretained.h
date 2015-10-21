//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface NSOrderedSet (NSValueNonretained)

- (BOOL)containsNonretainedObject:(id)aObject;

- (id)nonretainedObjectAtIndex:(NSUInteger)aIndex;

- (NSUInteger)indexOfNonretainedObject:(id)aObject;

- (id)firstNonretainedObject;
- (id)lastNonretainedObject;

- (NSOrderedSet *)nonretainedObjects;

- (void)enumerateNonretainedObjectsUsingBlock:(void (^)(id aObject, NSUInteger aIndex, BOOL *aStop))aBlock;

@end