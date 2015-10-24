//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "NSMutableOrderedSet+PNYNSValue.h"

@implementation NSMutableOrderedSet (PNYNSValue)

- (void)addNonretainedObject:(id)aObject
{
    [self addObject:[NSValue valueWithNonretainedObject:aObject]];
}

- (void)insertNonretainedObject:(id)aObject atIndex:(NSUInteger)aIndex
{
    [self insertObject:[NSValue valueWithNonretainedObject:aObject] atIndex:aIndex];
}

- (void)removeNonretainedObject:(id)aObject
{
    [self removeObject:[NSValue valueWithNonretainedObject:aObject]];
}

- (void)replaceNonretainedObjectAtIndex:(NSUInteger)aIndex withObject:(id)aObject
{
    [self replaceObjectAtIndex:aIndex withObject:[NSValue valueWithNonretainedObject:aObject]];
}

@end