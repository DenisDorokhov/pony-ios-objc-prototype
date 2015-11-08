//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

#import "PNYUtilityAssembly.h"
#import "PNYLogFormatter.h"
#import <Typhoon/TyphoonDefinition+Infrastructure.h>

@implementation PNYUtilityAssembly

#pragma mark - Private

- (id)configPostProcessor
{
    return [TyphoonDefinition configDefinitionWithName:@"Config.plist"];
}

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