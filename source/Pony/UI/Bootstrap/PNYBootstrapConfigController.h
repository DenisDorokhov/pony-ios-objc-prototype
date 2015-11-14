//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@protocol PNYBootstrapConfigController;

@protocol PNYBootstrapConfigControllerDelegate <NSObject>

- (void)bootstrapConfigControllerDidStartBackgroundActivity:(id <PNYBootstrapConfigController>)aStepController;
- (void)bootstrapConfigControllerDidFinishBackgroundActivity:(id <PNYBootstrapConfigController>)aStepController;

- (void)bootstrapConfigControllerDidRequestBootstrap:(id <PNYBootstrapConfigController>)aStepController;
- (void)bootstrapConfigControllerDidRequestOtherServer:(id <PNYBootstrapConfigController>)aStepController;

@end

@protocol PNYBootstrapConfigController <NSObject>

@property (nonatomic) BOOL active;

@property (nonatomic, weak) id <PNYBootstrapConfigControllerDelegate> delegate;

@end