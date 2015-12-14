//
//  TRZoomTransition.m
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

#import "TRZoomInRectForwardTransition.h"

#import "TRTransitionContext.h"
#import "TRTransitionViewControllerProtocol.h"
#import "TRTransitionConfiguration+ZoomTransition.h"

@interface TRZoomInRectForwardTransition ()

@end

@implementation TRZoomInRectForwardTransition

- (instancetype)initWithTransitionMode:(TRZoomInRectTransitionMode)transitionMode transitionClass:(TRTransitionClass)transitionClass
{
    if (self = [super init]) {
        self.transitionMode = transitionMode;
        self.transitionClass = transitionClass;
    }
    
    return self;
}

#pragma mark - TRZoomInRectTransition

- (void)performTransitionWithContext:(TRTransitionContext *)context configuration:(TRTransitionConfiguration *)configuration completionHandler:(BOOL (^)(BOOL))completionHandler
{
    NSAssert(configuration, @"You must provide a configuration object when calling <%@>", NSStringFromSelector(_cmd));
    switch (self.transitionMode) {
        case TRZoomInRectTransitionModeSameContent:
            [self _performZomIntoSimilarRectTransitionWithContext:context configuration:configuration completionHandler:completionHandler];
            break;
        case TRZoomInRectTransitionModeDifferentContent:
            [self _performZoomIntoDifferentRectTransitionWithContext:context configuration:configuration completionHandler:completionHandler];
            break;
        default:
            break;
    }
}

#pragma mark - Private Methods

- (void)_performZomIntoSimilarRectTransitionWithContext:(TRTransitionContext *)context configuration:(TRTransitionConfiguration *)configuration completionHandler:(BOOL (^)(BOOL finished))completionHandler
{
    if (!context || !configuration) {
        return;
    }
    
    UIViewController<TRTransitionViewControllerProtocol> *fromVC = context.fromVC;
    UIViewController<TRTransitionViewControllerProtocol> *toVC = context.toVC;
    UIView *containerView = context.containerView;
    
    if ([toVC respondsToSelector:@selector(viewControllerWillBeginTransitioning)]) {
        [toVC viewControllerWillBeginTransitioning];
    }
    
    toVC.view.alpha = 0.0;
    [containerView addSubview:toVC.view];
    
    CGRect targetRect = (configuration.targetRectBlock) ? configuration.targetRectBlock() : [TRZoomInRectTransitionHelper defaultTargetRectForRect:fromVC.view.frame];
    
    UIView *tmpBackgroundView = [TRZoomInRectTransitionHelper createDecorationViewForRefView:fromVC.view originalFrame:targetRect targetImage:configuration.targetImage];
    tmpBackgroundView.alpha = 0.0;
    [TRZoomInRectTransitionHelper configureDecorationView:tmpBackgroundView inReferenceView:fromVC.view];
    
    // Compute the transformation needed
    CGAffineTransform translateTransform = [TRZoomInRectTransitionHelper createZoomInTransformForView:fromVC.view originalFrame:targetRect targetImage:configuration.targetImage];
    CGAffineTransform initialTransform = fromVC.view.transform;
    
    CGAffineTransform initialToTransform = toVC.view.transform;
    toVC.view.transform = CGAffineTransformInvert(translateTransform);
    
    [UIView animateKeyframesWithDuration:configuration.duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
            fromVC.view.transform = translateTransform;
            tmpBackgroundView.alpha = 1.0;
            
            fromVC.view.alpha = 0.0;
            
            toVC.view.transform = initialToTransform;
            if ([toVC respondsToSelector:@selector(viewControllerIsTransitioning)]) {
                [toVC viewControllerIsTransitioning];
            }
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.5 animations:^{
            toVC.view.alpha = 1.0;
        }];
        
    } completion:^(BOOL finished) {
        if ([toVC respondsToSelector:@selector(viewControllerDidEndTransitioning)]) {
            [toVC viewControllerDidEndTransitioning];
        }
        
        fromVC.view.alpha = 1.0;
        fromVC.view.transform = initialTransform;
        [tmpBackgroundView removeFromSuperview];

        if (completionHandler) {
            completionHandler(finished);
        }
    }];
}

- (void)_performZoomIntoDifferentRectTransitionWithContext:(TRTransitionContext *)context configuration:(TRTransitionConfiguration *)configuration completionHandler:(BOOL (^)(BOOL finished))completionHandler
{
    PreTransitionBlock preBlock = [self _createPreConfigurationBlock:self.transitionClass];
    PostTransitionBlock postBlock = [self _createPostConfigurationBlock:self.transitionClass];
    
    if (!context || !configuration) {
        return;
    }
    
    UIViewController<TRTransitionViewControllerProtocol> *fromVC = context.fromVC;
    UIViewController<TRTransitionViewControllerProtocol> *toVC = context.toVC;
    UIView *containerView = context.containerView;
    
    if ([toVC respondsToSelector:@selector(viewControllerWillBeginTransitioning)]) {
        [toVC viewControllerWillBeginTransitioning];
    }
    
    toVC.view.alpha = 0.0;
    if (preBlock) {
        preBlock(containerView, toVC.view);
    }

    CGRect targetRect = (configuration.targetRectBlock) ? configuration.targetRectBlock() : [TRZoomInRectTransitionHelper defaultTargetRectForRect:fromVC.view.frame];
    
    // Compute the transformation needed
    CGAffineTransform translateTransform = [TRZoomInRectTransitionHelper createZoomInTransformForView:fromVC.view originalFrame:targetRect targetImage:nil];
    CGAffineTransform initialTransform = fromVC.view.transform;
    
    [UIView animateKeyframesWithDuration:configuration.duration delay:0.0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
            fromVC.view.alpha = 0.0;
            fromVC.view.transform = translateTransform;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.8 animations:^{
            toVC.view.alpha = 1.0;
            if ([toVC respondsToSelector:@selector(viewControllerIsTransitioning)]) {
                [toVC viewControllerIsTransitioning];
            }
        }];
        
    } completion:^(BOOL finished) {
        if ([toVC respondsToSelector:@selector(viewControllerDidEndTransitioning)]) {
            [toVC viewControllerDidEndTransitioning];
        }
        
        fromVC.view.transform = initialTransform;
        fromVC.view.alpha = 1.0;
        
        if (completionHandler) {
            completionHandler(finished);
        }
        
        if (postBlock) {
            postBlock(fromVC.view);
        }
    }];
}

#pragma mark - Private Methods

- (PreTransitionBlock)_createPreConfigurationBlock:(TRTransitionClass)transitionClass
{
    switch (transitionClass) {
        case TRTransitionClassSegue: {
            void(^block)(UIView *, UIView *) = ^(UIView *fromView, UIView *toView){
                [fromView.superview insertSubview:toView aboveSubview:fromView];
            };
            return block;
        }
        case TRTransitionClassNavigationTransition:{
            void(^block)(UIView *, UIView *) = ^(UIView *fromView, UIView *toView){
                [fromView addSubview:toView];
            };
            return block;
        }
            
        default:
            return nil;
    }
}

- (PostTransitionBlock)_createPostConfigurationBlock:(TRTransitionClass)transitionClass
{
    if(transitionClass == TRTransitionClassSegue) {
        void(^block)(UIView *) = ^(UIView *fromView){
            [fromView removeFromSuperview];
        };
        
        return block;
    }
    
    return nil;
}

@end
