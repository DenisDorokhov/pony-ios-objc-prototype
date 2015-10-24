//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@interface NSMutableOrderedSet (PNYNSValue)

- (void)addNonretainedObject:(id)aObject;

- (void)insertNonretainedObject:(id)aObject atIndex:(NSUInteger)aIndex;

- (void)removeNonretainedObject:(id)aObject;

- (void)replaceNonretainedObjectAtIndex:(NSUInteger)aIndex withObject:(id)aObject;

@end