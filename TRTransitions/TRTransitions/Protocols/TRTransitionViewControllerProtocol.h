//
//  TRTransitionViewControllerProtocol.h
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

@class TRTransition;
@class TRTransitionConfiguration;

// Make your UIViewController conform to this protocol if you want to have finer control of the transition
@protocol TRTransitionViewControllerProtocol <NSObject>

@optional

// Update the transition object with any necessary information such as the transitionConfiguration before the transition occurs. 
- (void)prepareTransition:(TRTransition *)transition;

// Implement this method when you have different UIViewControllers displayed at the same time but you do not want the view of the top-most to be used in the
// animation but one of the children UIViewControllers
// UIViewControllerAnimatedTransitioning operation but you do not want to use that view for the custom animation.
// Example: You are about to present a new UINavigationController but you do not want to use the view of the UINavigationController
// for the custom animation but the one from its rootViewController
- (UIViewController *)animatedViewController;

- (void)viewControllerWillBeginTransitioning;
- (void)viewControllerIsTransitioning;
- (void)viewControllerDidEndTransitioning;

@end