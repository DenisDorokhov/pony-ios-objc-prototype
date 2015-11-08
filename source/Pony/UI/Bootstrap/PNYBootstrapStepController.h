//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@protocol PNYBootstrapStepController;

@protocol PNYBootstrapStepControllerDelegate <NSObject>

- (void)bootstrapStepControllerDidStartBackgroundActivity:(id <PNYBootstrapStepController>)aStepController;
- (void)bootstrapStepControllerDidFinishBackgroundActivity:(id <PNYBootstrapStepController>)aStepController;
- (void)bootstrapStepControllerDidFailBackgroundActivity:(id <PNYBootstrapStepController>)aStepController;

- (void)bootstrapStepControllerDidRequestBootstrap:(id <PNYBootstrapStepController>)aStepController;

@end

@protocol PNYBootstrapStepController <NSObject>

@property (nonatomic, weak) id <PNYBootstrapStepControllerDelegate> delegate;

- (void)reset;
- (void)retry;

@end