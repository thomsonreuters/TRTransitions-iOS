//
//  TRTransitionCoordinator.m
//  TRZoomTransition-Sample

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

#import "TRTransitionCoordinator.h"

#import "TRZDefaultViewController.h"
#import "TRZSingleAssetViewController.h"
#import "TRZSettingsViewController.h"
#import "TRZViewController.h"

#import <TRTransitions/TRTransitionRegistry.h>
#import <TRTransitions/TRZoomInRectForwardTransition.h>
#import <TRTransitions/TRZoomInRectBackwardTransition.h>

@implementation TRTransitionCoordinator

+ (void)registerTransitions
{
    TRZoomInRectForwardTransition *forwardSameTransitionAgent = [[TRZoomInRectForwardTransition alloc] initWithTransitionMode:TRZoomInRectTransitionModeSameContent
                                                                                                         transitionClass:TRTransitionClassNavigationTransition];
    TRTransition *forwardSameTransition = [[TRTransition alloc] initWithConfiguration:nil transitionAgent:forwardSameTransitionAgent];
    
    TRZoomInRectForwardTransition *forwardDifferentTransitionAgent = [[TRZoomInRectForwardTransition alloc] initWithTransitionMode:TRZoomInRectTransitionModeDifferentContent
                                                                                                              transitionClass:TRTransitionClassNavigationTransition];
    TRTransition *forwardDifferentTransition = [[TRTransition alloc] initWithConfiguration:nil transitionAgent:forwardDifferentTransitionAgent];

    TRZoomInRectBackwardTransition *backwardSameTransitionAgent = [[TRZoomInRectBackwardTransition alloc] initWithTransitionMode:TRZoomInRectTransitionModeSameContent];
    TRTransition *backwardSameTransition = [[TRTransition alloc] initWithConfiguration:nil transitionAgent:backwardSameTransitionAgent];
    
    TRZoomInRectBackwardTransition *backwardDifferentTransitionAgent = [[TRZoomInRectBackwardTransition alloc] initWithTransitionMode:TRZoomInRectTransitionModeDifferentContent];
    TRTransition *backwardDifferentTransition = [[TRTransition alloc] initWithConfiguration:nil transitionAgent:backwardDifferentTransitionAgent];
    
    NSString *saForwardTransitionIdentifier         = [TRTransitionRegistry createTransitionIdentifier:nil
                                                                                 toViewControllerClass:[TRZSingleAssetViewController class]];
    NSString *saBackwardTransitionIdentifier        = [TRTransitionRegistry createTransitionIdentifier:[TRZSingleAssetViewController class]
                                                                                 toViewControllerClass:nil];
    
    NSString *zoomInRectForwardTransitionIdentifier    = [TRTransitionRegistry createTransitionIdentifier:[TRZViewController class]
                                                                                    toViewControllerClass:[TRZSettingsViewController class]];

    NSString *zoomInRectBackwardTransitionIdentifier   = [TRTransitionRegistry createTransitionIdentifier:[TRZSettingsViewController class]
                                                                                    toViewControllerClass:[TRZViewController class]];
    
    NSString *defaultInRectForwardTransitionIdentifier    = [TRTransitionRegistry createTransitionIdentifier:[TRZDefaultViewController class]
                                                                                       toViewControllerClass:[TRZSettingsViewController class]];
    NSString *defaultInRectBackwardTransitionIdentifier   = [TRTransitionRegistry createTransitionIdentifier:[TRZSettingsViewController class]
                                                                                       toViewControllerClass:[TRZDefaultViewController class]];
    
    [[TRTransitionRegistry sharedInstance] registerTransition:forwardSameTransition withIdentifier:saForwardTransitionIdentifier];
    [[TRTransitionRegistry sharedInstance] registerTransition:backwardSameTransition withIdentifier:saBackwardTransitionIdentifier];
    
    [[TRTransitionRegistry sharedInstance] registerTransition:forwardDifferentTransition withIdentifier:zoomInRectForwardTransitionIdentifier];
    [[TRTransitionRegistry sharedInstance] registerTransition:backwardDifferentTransition withIdentifier:zoomInRectBackwardTransitionIdentifier];
    
    [[TRTransitionRegistry sharedInstance] registerTransition:forwardDifferentTransition withIdentifier:defaultInRectForwardTransitionIdentifier];
    [[TRTransitionRegistry sharedInstance] registerTransition:backwardDifferentTransition withIdentifier:defaultInRectBackwardTransitionIdentifier];
}

@end
