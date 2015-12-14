//
//  TRTransitionImageHelper.m
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

#import "TRZoomTransitionImageHelper.h"

@implementation TRZoomTransitionImageHelper

// If it is a square image, it is classified as a portrait image (jjramos 02.05.14)
+ (TRTransitionImageOrientation)orientationForImage:(UIImage *)image
{
    return (image.size.width > image.size.height) ? TRTransitionImageOrientationLandscape : TRTransitionImageOrientationPortrait;
}

+ (UIViewContentMode)suggestedContentModeForImage:(UIImage *)image
{
    return ([TRZoomTransitionImageHelper orientationForImage:image] == TRTransitionImageOrientationLandscape) ? UIViewContentModeScaleAspectFill : UIViewContentModeScaleAspectFit;
}

+ (CGSize)presentedImageSize:(UIImage*)image forRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode
{
    NSAssert(contentMode==UIViewContentModeScaleAspectFill || contentMode==UIViewContentModeScaleAspectFit, @"The current implementation of <%@> only supports contentModes of AspectFill or AspectFit", NSStringFromSelector(_cmd));
    
    if (contentMode!=UIViewContentModeScaleAspectFill && contentMode!=UIViewContentModeScaleAspectFit) {
        return CGSizeZero;
    }
    
    CGFloat imageRatio = image.size.width / image.size.height;
    
    // Compute the deltas. Based on the image aspect ratio,
    CGFloat diffWidth = (image.size.width - rect.size.width);
    CGFloat diffHeight = (image.size.height - rect.size.height) * imageRatio;
    
    CGFloat imgWidth = 0.0;
    CGFloat imgHeight = 0.0;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            if (diffWidth < diffHeight) {
                // It has adjusted the width of the image to match the frame
                imgWidth = rect.size.width;
                imgHeight = (1.0/imageRatio) * imgWidth;
            }
            else {
                // It has adjusted the height of the image to match the frame
                imgHeight = rect.size.height;
                imgWidth = imageRatio * imgHeight;
            }
            break;
        case UIViewContentModeScaleAspectFit:
            if (diffWidth > diffHeight) {
                // It has adjusted the width of the image to match the frame
                imgWidth = rect.size.width;
                imgHeight = (1.0/imageRatio) * imgWidth;
            }
            else {
                // It has adjusted the height of the image to match the frame
                imgHeight = rect.size.height;
                imgWidth = imageRatio * imgHeight;
            }
            break;
            
        default:
            NSAssert(FALSE, @"<SUSZoomInTransition. Cells containing photos in the zoom in transition must have their content mode values either to aspect fill or aspect fit>");
            break;
    }
    
    
    return CGSizeMake(imgWidth, imgHeight);
}

@end
