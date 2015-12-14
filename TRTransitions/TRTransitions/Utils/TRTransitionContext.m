//
//  TRTransitionContext.m
//  TRZoomTransition

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

#import "TRTransitionContext.h"

#import "TRTransitionViewControllerProtocol.h"

@interface TRTransitionContext ()

@property (strong, nonatomic) UIViewController<TRTransitionViewControllerProtocol> *fromVC;
@property (strong, nonatomic) UIViewController<TRTransitionViewControllerProtocol> *toVC;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) id<UIViewControllerContextTransitioning> contextTransitioning;

@end

@implementation TRTransitionContext

- (instancetype)initWithContextTransitioning:(id<UIViewControllerContextTransitioning>)context
{
    if (self = [super init]) {
        UIViewController<TRTransitionViewControllerProtocol> *sourceViewController = (UIViewController<TRTransitionViewControllerProtocol>*)[context viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController<TRTransitionViewControllerProtocol> *destinationViewController = (UIViewController<TRTransitionViewControllerProtocol>*)[context viewControllerForKey:UITransitionContextToViewControllerKey];
        
        self.fromVC = ([sourceViewController respondsToSelector:@selector(animatedViewController)]) ? (UIViewController<TRTransitionViewControllerProtocol> *)[sourceViewController animatedViewController] : sourceViewController;
        self.toVC = ([destinationViewController respondsToSelector:@selector(animatedViewController)]) ? (UIViewController<TRTransitionViewControllerProtocol> *)[destinationViewController animatedViewController] : destinationViewController;
        self.containerView = [context containerView];
        self.contextTransitioning = context;
    }
    
    return self;
}

- (instancetype)initWithFromVC:(UIViewController<TRTransitionViewControllerProtocol> *)fromVC toVC:(UIViewController<TRTransitionViewControllerProtocol> *)toVC
{
    if (self = [super init]) {
        self.fromVC = fromVC;
        self.toVC = toVC;
    }
    return self;
}

- (BOOL)transitionWasCancelled
{
    return (self.contextTransitioning) ? [self.contextTransitioning transitionWasCancelled] : NO;
}

#pragma mark - Getter and Setters

// To make it compatible with Segues and View Controller Animated Transitions, the getter is modified.
// In a View Controller Animated Transition we should expect to have the containerView specified.
// In a Segue or as a fallback, we use the toViewController's view
- (UIView *)containerView
{
    return (_containerView) ?: self.fromVC.view;
}

@end
