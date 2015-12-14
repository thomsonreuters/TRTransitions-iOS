//
//  SUSZoomInTransitionConfiguration.m
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

#import "TRTransitionConfiguration.h"

NSTimeInterval const kDefaultAnimationDuration = 0.3;

@interface TRTransitionConfiguration()

@property (assign, nonatomic) NSTimeInterval duration;

@end

@implementation TRTransitionConfiguration

- (instancetype)initWithDuration:(NSTimeInterval)duration
{
    if (self = [super init]) {
        self.duration = duration;
    }
    
    return self;
}

- (instancetype)initWithDuration:(NSTimeInterval)duration additionalProperties:(NSDictionary *)properties
{
    if (self = [self initWithDuration:duration]) {
        self.additionalProperties = properties;
    }
    
    return self;
}

- (instancetype)initWithDuration:(NSTimeInterval)duration additionalProperties:(NSDictionary *)properties completionHandler:(BOOL(^)(BOOL finished))completionHandler
{
    if (self = [self initWithDuration:duration additionalProperties:properties]) {
        self.completionHandler = completionHandler;
    }
    
    return self;
}

@end
