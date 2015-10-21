//
// Created by Denis Dorokhov on 21/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "NSOrderedSet+NSValueNonretained.h"

@implementation NSOrderedSet (NSValueNonretained)

- (BOOL)containsNonretainedObject:(id)aObject
{
    return [self containsObject:[NSValue valueWithNonretainedObject:aObject]];
}

- (id)nonretainedObjectAtIndex:(NSUInteger)aIndex
{
    return [(NSValue *)[self objectAtIndex:aIndex] nonretainedObjectValue];
}

- (NSUInteger)indexOfNonretainedObject:(id)aObject
{
    return [self indexOfObject:[NSValue valueWithNonretainedObject:aObject]];
}

- (id)firstNonretainedObject
{
    return [(NSValue *)[self firstObject] nonretainedObjectValue];
}

- (id)lastNonretainedObject
{
    return [(NSValue *)[self lastObject] nonretainedObjectValue];
}

- (NSOrderedSet *)nonretainedObjects
{
    NSMutableArray *nonretainedObjects = [NSMutableArray array];
    for (NSValue *value in self) {
        [nonretainedObjects addObject:[value nonretainedObjectValue]];
    }
    return [NSOrderedSet orderedSetWithArray:nonretainedObjects];
}

- (void)enumerateNonretainedObjectsUsingBlock:(void (^)(id aObject, NSUInteger aIndex, BOOL *aStop))aBlock
{
    [self enumerateObjectsUsingBlock:^(NSValue *aObject, NSUInteger aIndex, BOOL *aStop) {
        aBlock([aObject nonretainedObjectValue], aIndex, aStop);
    }];
}

@end