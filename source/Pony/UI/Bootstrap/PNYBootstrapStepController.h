//
// Created by Denis Dorokhov on 08/11/15.
// Copyright (c) 2015 Denis Dorokhov. All rights reserved.
//

@protocol PNYBootstrapStepController;

@protocol PNYBootstrapStepControllerDelegate <NSObject>

- (void)bootstrapStepControllerDidStartActivity:(id <PNYBootstrapStepController>)aStepController;
- (void)bootstrapStepControllerDidFinishActivity:(id <PNYBootstrapStepController>)aStepController;
- (void)bootstrapStepControllerDidFailActivity:(id <PNYBootstrapStepController>)aStepController;

@end

@protocol PNYBootstrapStepController <NSObject>

@property (nonatomic, weak) id <PNYBootstrapStepControllerDelegate> delegate;

@end