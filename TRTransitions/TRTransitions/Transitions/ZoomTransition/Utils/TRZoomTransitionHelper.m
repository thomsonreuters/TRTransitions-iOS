//
//  TRTransitionHelper.m
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

#import "TRZoomTransitionHelper.h"

@implementation TRZoomTransitionHelper

+ (CGAffineTransform)transformUpscaleView:(UIView *)view toRect:(CGRect)rect
{
    CGFloat scale = MAX(view.bounds.size.width / rect.size.width, view.bounds.size.height / rect.size.height);
    
    return CGAffineTransformScale(view.transform, scale, scale);
}

+ (CGAffineTransform)transformDownscaleView:(UIView *)view toRect:(CGRect)rect
{
    CGFloat scale = MAX(rect.size.width / view.bounds.size.width, rect.size.height / view.bounds.size.height);
    
    return CGAffineTransformScale(view.transform, scale, scale);
}

@end
