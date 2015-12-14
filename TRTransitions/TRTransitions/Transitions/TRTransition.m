//
//  TRTransition.m
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
#import "TRTransition.h"
#import "TRTransitionConfiguration.h"
#import "TRTransitionProtocol.h"
#import "TRTransitionViewControllerProtocol.h"

@interface TRTransition ()

@end

@implementation TRTransition

- (instancetype)initWithConfiguration:(TRTransitionConfiguration *)configuration transitionAgent:(id<TRTransitionProtocol>)transitionAgent
{
    if (self = [super init]) {
        self.configuration = configuration;
        self.transitionAgent = transitionAgent;
        NSAssert([self isMemberOfClass:self.class], @"You are not allowed to instantiate <%@> objects. Use one of its subclasses instead", NSStringFromClass(self.class));
    }
    
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    TRTransitionContext *context = [[TRTransitionContext alloc] initWithContextTransitioning:transitionContext];
    
    __weak typeof(self) weakSelf = self;
    BOOL(^completionHandler)(BOOL finished) = ^BOOL(BOOL finished) {
        BOOL transitionWasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!transitionWasCancelled];
        
        if (weakSelf.configuration.completionHandler) {
            weakSelf.configuration.completionHandler(transitionWasCancelled);
        }

        return transitionWasCancelled;
    };
    
    [self.transitionAgent performTransitionWithContext:context configuration:self.configuration completionHandler:completionHandler];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    NSAssert(self.configuration, @"Inconsistency Exception. Before <%@> is called, the <%@> property must have been set", NSStringFromSelector(_cmd), NSStringFromClass([TRTransitionConfiguration class]));
    
    return self.configuration.duration;
}

@end
