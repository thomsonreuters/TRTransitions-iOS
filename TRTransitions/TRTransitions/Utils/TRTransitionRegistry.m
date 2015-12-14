//
//  TRTransitionRegistry.m
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

#import "TRTransitionRegistry.h"

#import "TRTransitionInteractiveViewController.h"
#import "TRTransition.h"
#import "TRTransitionViewControllerProtocol.h"

NSString *const kTRTransitionSeparator = @"-";
NSString *const kTRTransitionWildCardIdentifier = @"*";

static dispatch_once_t onceToken;
static TRTransitionRegistry *__registry;

@interface TRTransitionRegistry ()

@property (strong, nonatomic) NSMutableDictionary *transitions;

@end

@implementation TRTransitionRegistry

+ (instancetype)sharedInstance
{
    dispatch_once(&onceToken, ^{
        __registry = [[TRTransitionRegistry alloc] init];
    });
    
    return __registry;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.transitions = [NSMutableDictionary new];
    }
    
    return self;
}

- (void)registerTransition:(TRTransition *)transition withIdentifier:(TRTransitionIdentifier *)transitionIdentifier
{
    self.transitions[transitionIdentifier] = transition;
}

- (TRTransition *)transitionForIdentifier:(TRTransitionIdentifier *)transitionIdentifier
{
    return self.transitions[transitionIdentifier];
}

+ (TRTransitionIdentifier *)createTransitionIdentifier:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [self createTransitionIdentifier:fromVC.class toViewControllerClass:toVC.class];
}

+ (TRTransitionIdentifier *)createTransitionIdentifier:(__unsafe_unretained Class)fromVCClass toViewControllerClass:(__unsafe_unretained Class)toVCClass
{
    NSAssert(fromVCClass || toVCClass, @"For the UIViewControllers involved in the transition, you must provide at least one of them");
    NSString *fromIdentifier = [self _identifierForVC:fromVCClass];
    NSString *toIdentifier = [self _identifierForVC:toVCClass];
    
    return [NSString stringWithFormat:@"%@%@%@", fromIdentifier, kTRTransitionSeparator, toIdentifier];
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    TRTransition *transition = [self _transitionWithFromViewController:fromVC.class toViewController:toVC.class];
    if ([fromVC conformsToProtocol:@protocol(TRTransitionViewControllerProtocol)] && [fromVC respondsToSelector:@selector(prepareTransition:)]) {
        [(id<TRTransitionViewControllerProtocol>)fromVC prepareTransition:transition];
    }

    return transition;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[TRTransition class]]) {
        return [(TRTransition *)animationController interactiveController];
    }
    
    return nil;

}

#pragma mark - UITabBarControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController animationControllerForTransitionFromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    return nil;
}

#pragma mark - Private Methods

- (TRTransition *)_transitionWithFromViewController:(__unsafe_unretained Class)fromVC toViewController:(__unsafe_unretained Class)toVC
{
    NSString *transitionIdentifier = [TRTransitionRegistry createTransitionIdentifier:fromVC toViewControllerClass:toVC];
    __block TRTransition *transitionValue = nil;
    [self.transitions enumerateKeysAndObjectsUsingBlock:^(NSString *key, TRTransition *obj, BOOL *stop) {
        if ([self _transition:transitionIdentifier canBeHandledByTransition:key]) {
            transitionValue = self.transitions[key];
            *stop = YES;
        }
    }];
    
    return transitionValue;
}

+ (NSString *)_identifierForVC:(__unsafe_unretained Class)vc
{
    return (vc) ? NSStringFromClass(vc) : kTRTransitionWildCardIdentifier;
}

- (BOOL)_transition:(NSString *)transitionToHappen canBeHandledByTransition:(NSString *)transitionIdentifier
{
    NSArray *componentsToHappen = [transitionToHappen componentsSeparatedByString:kTRTransitionSeparator];
    NSArray *transitionComponents = [transitionIdentifier componentsSeparatedByString:kTRTransitionSeparator];
    
    if (componentsToHappen.count != 2 || transitionComponents.count != 2) {
        return NO;
    }
    
    BOOL firstPart = [[transitionComponents firstObject] isEqualToString:kTRTransitionWildCardIdentifier] || [[transitionComponents firstObject] isEqualToString:[componentsToHappen firstObject]];
    BOOL secondPart = [[transitionComponents lastObject] isEqualToString:kTRTransitionWildCardIdentifier] || [[transitionComponents lastObject] isEqualToString:[componentsToHappen lastObject]];
    
    return firstPart && secondPart;
}

@end
