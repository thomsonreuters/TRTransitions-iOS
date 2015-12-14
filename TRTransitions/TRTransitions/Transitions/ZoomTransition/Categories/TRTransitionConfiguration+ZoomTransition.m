//
//  TRTransitionConfiguration+ZoomTransition.m
//  TRTransitions

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

#import "TRTransitionConfiguration+ZoomTransition.h"

NSString *const kTRTransitionTargetRect = @"targetRect";
NSString *const kTRTransitionTargetImage = @"targetimage";

@implementation TRTransitionConfiguration (ZoomTransition)

- (void)setTargetImage:(UIImage *)targetImage
{
    @synchronized(self.additionalProperties) {
        NSMutableDictionary *mutableProperties = (self.additionalProperties) ? [self.additionalProperties mutableCopy] : [NSMutableDictionary new];
        [mutableProperties setObject:targetImage forKey:kTRTransitionTargetImage];
        self.additionalProperties = mutableProperties;
    }
}

- (void)setTargetRectBlock:(CGRect (^)(void))targetRectBlock
{
    @synchronized(self.additionalProperties) {
        NSMutableDictionary *mutableProperties = (self.additionalProperties) ? [self.additionalProperties mutableCopy] : [NSMutableDictionary new];
        [mutableProperties setObject:[targetRectBlock copy] forKey:kTRTransitionTargetRect];
        self.additionalProperties = mutableProperties;
    }
}

- (UIImage *)targetImage
{
    return self.additionalProperties[kTRTransitionTargetImage];
}

- (CGRect(^)(void))targetRectBlock
{
    return self.additionalProperties[kTRTransitionTargetRect];
}

@end
