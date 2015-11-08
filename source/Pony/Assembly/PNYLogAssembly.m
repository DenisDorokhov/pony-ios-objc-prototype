//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYLogAssembly.h"
#import "PNYLogFormatter.h"

@implementation PNYLogAssembly

#pragma mark - Private

- (id)logging
{
    return [TyphoonDefinition withClass:[DDLog class] configuration:^(TyphoonDefinition *definition) {
        definition.scope = TyphoonScopeSingleton;
        [definition useInitializer:@selector(class)];
        [definition injectMethod:@selector(addLogger:) parameters:^(TyphoonMethod *aMethod) {
            [aMethod injectParameterWith:[self ttyLogger]];
        }];
    }];
}

- (id <DDLogger>)ttyLogger
{
    return [TyphoonDefinition withClass:[DDTTYLogger class] configuration:^(TyphoonDefinition *aDefinition) {
        [aDefinition useInitializer:@selector(sharedInstance)];
        [aDefinition injectProperty:@selector(logFormatter) with:[self logFormatter]];
    }];
}

- (id <DDLogFormatter>)logFormatter
{
    return [TyphoonDefinition withClass:[PNYLogFormatter class]];
}

@end