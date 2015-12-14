//
//  SUSZoomInTransitionConfiguration.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TRTransitionConfiguration : NSObject
@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, copy) BOOL(^completionHandler)(BOOL finished);
@property (nonatomic, strong) NSDictionary *additionalProperties;

- (instancetype)initWithDuration:(NSTimeInterval)duration;

- (instancetype)initWithDuration:(NSTimeInterval)duration additionalProperties:(NSDictionary *)properties;

- (instancetype)initWithDuration:(NSTimeInterval)duration additionalProperties:(NSDictionary *)properties completionHandler:(BOOL(^)(BOOL finished))completionHandler;

@end
