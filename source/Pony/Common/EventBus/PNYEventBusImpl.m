//
// Created by Denis Dorokhov on 11/10/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYEventBusImpl.h"

@interface PNYEventBus_Invocation : NSObject

@property (nonatomic, readonly) id object;
@property (nonatomic, readonly) SEL selector;

@end

@implementation PNYEventBus_Invocation
{
@private
    NSUInteger hash;
}

+ (instancetype)invocationWithObject:(id)aObject selector:(SEL)aSelector
{
    return [[self alloc] initWithObject:aObject selector:aSelector];
}

- (instancetype)initWithObject:(id)aObject selector:(SEL)aSelector
{
    self = [self init];

    if (self != nil) {

        _object = aObject;
        _selector = aSelector;

        hash = [self.object hash] ^ [NSStringFromSelector(self.selector) hash];
    }

    return self;
}

- (BOOL)isEqual:(PNYEventBus_Invocation *)aInvocation
{
    return self.object == aInvocation.object && self.selector == aInvocation.selector;
}

- (NSUInteger)hash
{
    return hash;
}

@end

@implementation PNYEventBusImpl
{
@private
    NSMutableDictionary *typeToInvocations; // NSString => NSMutableOrderedSet of PNYEventBus_Invocation.
}

- (instancetype)init
{
    self = [super init];

    if (self != nil) {
        typeToInvocations = [NSMutableDictionary dictionary];
    }

    return self;
}

#pragma mark - Public

- (void)addListener:(NSString *)aType object:(id)aObject selector:(SEL)aSelector
{
    [[self invocationsForType:aType] addObject:[PNYEventBus_Invocation invocationWithObject:aObject selector:aSelector]];
}

- (void)removeListener:(NSString *)aType object:(id)aObject selector:(SEL)aSelector
{
    [[self invocationsForType:aType] removeObject:[PNYEventBus_Invocation invocationWithObject:aObject selector:aSelector]];
}

- (void)removeListenersWithObject:(id)aObject
{
    [typeToInvocations enumerateKeysAndObjectsUsingBlock:^(NSString *aType, NSMutableOrderedSet *aInvocations, BOOL *aStop) {

        NSMutableArray *invocationsToRemove = [NSMutableArray array];

        for (PNYEventBus_Invocation *invocation in aInvocations) {
            if (invocation.object == aObject) {
                [invocationsToRemove addObject:invocation];
            }
        }

        [aInvocations removeObjectsInArray:invocationsToRemove];
    }];
}

- (void)fireEvent:(PNYEvent *)aEvent
{
    for (PNYEventBus_Invocation *invocation in [self invocationsForType:aEvent.type]) {

        if (aEvent.cancelled) {
            break;
        }

        NSMethodSignature *methodSignature = [[invocation.object class] instanceMethodSignatureForSelector:invocation.selector];
        NSInvocation *methodInvocation = [NSInvocation invocationWithMethodSignature:methodSignature];

        methodInvocation.target = invocation.object;
        methodInvocation.selector = invocation.selector;

        if (methodSignature.numberOfArguments >= 3) {
            [methodInvocation setArgument:&aEvent atIndex:2];
        }

        [methodInvocation invoke];
    }
}

#pragma mark - Private

- (NSMutableOrderedSet *)invocationsForType:(NSString *)aType
{
    NSMutableOrderedSet *listenerSelectors = typeToInvocations[aType];

    if (listenerSelectors == nil) {

        listenerSelectors = [NSMutableOrderedSet orderedSet];

        typeToInvocations[aType] = listenerSelectors;
    }

    return listenerSelectors;
}

@end