//
//  TRZoomTransition.h
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

#import "TRTransitionProtocol.h"
#import "TRZoomInRectTransitionHelper.h"

@interface TRZoomInRectForwardTransition : NSObject <TRTransitionProtocol>

/** @property transitionMode
 *   @brief Specify whether the zoom is going to be done onto similar or different content
 *   Most of the time the zoom; i.e., will be done to different content. An example where you
 *   may want to zoom into similar content is when you have a UICollectionView cell that after
 *   tapping on it you want to display it full screen
 **/
@property (assign, nonatomic) TRZoomInRectTransitionMode transitionMode;
/** @property transitionClass
 *   @brief Specify whether the transition is going to happen in a Custom Segue or as part of a
 *   Custom Navigation Transition.
 **/
@property (assign, nonatomic) TRTransitionClass transitionClass;

- (instancetype)initWithTransitionMode:(TRZoomInRectTransitionMode)transitionMode transitionClass:(TRTransitionClass)transitionClass;

@end
