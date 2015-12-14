//
//  TRTransition.h
//  TRTransitions

/*******************************************************************************
 * Copyright 2015 Thomson Reuters
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *******************************************************************************/

@protocol TRTransitionProtocol;
@class TRTransitionConfiguration;

// Subclass TRTransition to create your custom animations. Make sure you overwrite:
// performTransitionWithContext:configuration:completionHandle where you would implement your custom transition

@interface TRTransition : NSObject <UIViewControllerAnimatedTransitioning>

@property (strong, nonatomic) TRTransitionConfiguration *configuration;
@property (strong, nonatomic) id<TRTransitionProtocol> transitionAgent;
@property (weak, nonatomic) id<UIViewControllerInteractiveTransitioning> interactiveController;

- (instancetype)initWithConfiguration:(TRTransitionConfiguration *)configuration transitionAgent:(id<TRTransitionProtocol>)transitionAgent NS_REQUIRES_SUPER;

@end
