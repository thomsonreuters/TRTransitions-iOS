//
//  TRZoomInRectBackTransition.m
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

#import "TRZoomInRectBackwardTransition.h"

#import "TRTransitionContext.h"
#import "TRTransitionViewControllerProtocol.h"
#import "TRTransitionConfiguration+ZoomTransition.h"

@interface TRZoomInRectBackwardTransition ()

@end

@implementation TRZoomInRectBackwardTransition

- (instancetype)initWithTransitionMode:(TRZoomInRectTransitionMode)transitionMode
{
    if (self = [super init]) {
        self.transitionMode = transitionMode;
    }
    
    return self;
}

#pragma mark - TRZoomInRectTransition

- (void)performTransitionWithContext:(TRTransitionContext *)context configuration:(TRTransitionConfiguration *)configuration completionHandler:(BOOL (^)(BOOL))completionHandler
{
    switch (self.transitionMode) {
        case TRZoomInRectTransitionModeSameContent:
            [self _performZomIntoSimilarRectTransitionWithContext:context configuration:configuration completionHandler:completionHandler];
            break;
        case TRZoomInRectTransitionModeDifferentContent:
            [self _performZomIntoDifferentRectTransitionWithContext:context configuration:configuration completionHandler:completionHandler];
            break;
        default:
            break;
    }
}

#pragma mark - Private Methods

- (void)_performZomIntoSimilarRectTransitionWithContext:(TRTransitionContext *)context configuration:(TRTransitionConfiguration *)configuration completionHandler:(BOOL (^)(BOOL finished))completionHandler
{
    NSAssert(configuration, @"You must provide a configuration object when calling <%@>", NSStringFromSelector(_cmd));
    
    if (!context || !configuration) {
        return;
    }
    
    UIViewController<TRTransitionViewControllerProtocol> *fromVC = context.fromVC;
    UIViewController<TRTransitionViewControllerProtocol> *toVC = context.toVC;
    UIView *containerView = context.containerView;
    
    CGAffineTransform finalTransform = toVC.view.transform;
    
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    CGRect targetRect = (configuration.targetRectBlock) ? configuration.targetRectBlock() : [TRZoomInRectTransitionHelper defaultTargetRectForRect:fromVC.view.frame];
    
    if ([fromVC respondsToSelector:@selector(viewControllerWillBeginTransitioning)]) {
        [fromVC viewControllerWillBeginTransitioning];
    }
    
    // Compute the transformation needed
    CGAffineTransform initialTransform = [TRZoomInRectTransitionHelper createZoomInTransformForView:toVC.view originalFrame:targetRect targetImage:configuration.targetImage];
    CGAffineTransform intermediateFromTransform = CGAffineTransformInvert(initialTransform);
    
    toVC.view.transform = initialTransform;
    
    // Using a temporary view to act as the fromVC.view during the transition. Using fromVC.view was leaving the view hierarchy in an inconsistent state
    // when the transition was cancelled (jjramos 16.05.14)
    UIView *fromView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    [containerView insertSubview:fromView aboveSubview:fromVC.view];
    fromView.frame = fromVC.view.frame;
    fromVC.view.alpha = 0.0;
    UIView *tmpBackgroundView = [TRZoomInRectTransitionHelper createDecorationViewForRefView:toVC.view originalFrame:targetRect targetImage:configuration.targetImage];
    tmpBackgroundView.alpha = 1.0;
    [TRZoomInRectTransitionHelper configureDecorationView:tmpBackgroundView inReferenceView:toVC.view];
    
    [UIView animateKeyframesWithDuration:configuration.duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
            toVC.view.transform = finalTransform;
            
            fromView.transform = intermediateFromTransform;
            tmpBackgroundView.alpha = 0.0;
            
            if ([fromVC respondsToSelector:@selector(viewControllerIsTransitioning)]) {
                [fromVC viewControllerIsTransitioning];
            }
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.25 animations:^{
            fromView.alpha = 0.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
            toVC.navigationController.navigationBar.alpha = 1.0;
        }];
        
    } completion:^(BOOL finished) {
        if ([fromVC respondsToSelector:@selector(viewControllerDidEndTransitioning)]) {
            [fromVC viewControllerDidEndTransitioning];
        }
        fromVC.view.alpha = 1.0;
        
        [tmpBackgroundView removeFromSuperview];
        [fromView removeFromSuperview];
        
        BOOL transitionWasCancelled = [context transitionWasCancelled];
        
        if (transitionWasCancelled == NO) {
            [fromVC.view removeFromSuperview];
        }
        else {
            toVC.view.transform = finalTransform;
            [toVC.view removeFromSuperview];
        }
        
        if (completionHandler) {
            completionHandler(finished);
        }
    }];
}

- (void)_performZomIntoDifferentRectTransitionWithContext:(TRTransitionContext *)context configuration:(TRTransitionConfiguration *)configuration completionHandler:(BOOL (^)(BOOL finished))completionHandler
{    
    if (!context || !configuration) {
        return;
    }
    
    UIViewController<TRTransitionViewControllerProtocol> *fromVC = context.fromVC;
    UIViewController<TRTransitionViewControllerProtocol> *toVC = context.toVC;
    UIView *containerView = [context.containerView snapshotViewAfterScreenUpdates:NO];
    
    [fromVC.view addSubview:containerView];
    
    if ([toVC respondsToSelector:@selector(viewControllerWillBeginTransitioning)]) {
        [toVC viewControllerWillBeginTransitioning];
    }
    
    toVC.view.alpha = 0.0;
    [fromVC.view.superview addSubview:toVC.view];
    
    CGRect targetRect = (configuration.targetRectBlock) ? configuration.targetRectBlock() : [TRZoomInRectTransitionHelper defaultTargetRectForRect:fromVC.view.frame];
    
    // Compute the transformation needed
    CGAffineTransform initialTransform = fromVC.view.transform;
    CGAffineTransform transform = [TRZoomInRectTransitionHelper createZoomOutTransformForView:fromVC.view originalFrame:targetRect targetImage:nil];
    
    [UIView animateKeyframesWithDuration:configuration.duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.8 animations:^{
            fromVC.view.transform = transform;
            fromVC.view.alpha = 0.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
            toVC.view.alpha = 1.0;
            if ([toVC respondsToSelector:@selector(viewControllerIsTransitioning)]) {
                [toVC viewControllerIsTransitioning];
            }
            
        }];
        
    } completion:^(BOOL finished) {
        if ([toVC respondsToSelector:@selector(viewControllerDidEndTransitioning)]) {
            [toVC viewControllerDidEndTransitioning];
        }
        
        fromVC.view.alpha = 1.0;
        fromVC.view.transform = initialTransform;
        
        if (completionHandler) {
            completionHandler(finished);
        }
    }];
}

@end
