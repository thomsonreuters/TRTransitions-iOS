//
//  TRZoomInRectTransitionHelper.m
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

#import "TRZoomInRectTransitionHelper.h"
#import "TRZoomTransitionImageHelper.h"

@implementation TRZoomInRectTransitionHelper

+ (CGAffineTransform)createZoomInTransformForView:(UIView*)view originalFrame:(CGRect)originalFrame targetImage:(UIImage *)targetImage
{
    CGRect viewFrame = view.bounds;
    CGFloat scale = 0.0;
    
    CGSize actualImageSize;
    if (targetImage) {
        UIViewContentMode contentMode = [TRZoomTransitionImageHelper suggestedContentModeForImage:targetImage];
        actualImageSize = [TRZoomTransitionImageHelper presentedImageSize:targetImage forRect:originalFrame contentMode:contentMode];
    }
    else {
        actualImageSize = originalFrame.size;
    }
    
    scale = MIN(viewFrame.size.width / actualImageSize.width, viewFrame.size.height / actualImageSize.height);
    
    CGFloat tx = CGRectGetMidX(viewFrame) - CGRectGetMidX(originalFrame);
    CGFloat ty = CGRectGetMidY(viewFrame) - CGRectGetMidY(originalFrame);
    
    CGAffineTransform scaleTransform = CGAffineTransformScale(view.transform, scale, scale);
    CGAffineTransform transform = CGAffineTransformTranslate(scaleTransform, tx, ty);
    
    return transform;
}

+ (CGAffineTransform)createZoomOutTransformForView:(UIView*)view originalFrame:(CGRect)originalFrame targetImage:(UIImage *)targetImage
{
    CGRect viewFrame = view.bounds;
    CGFloat scale = 0.0;
    
    CGSize actualImageSize;
    if (targetImage) {
        UIViewContentMode contentMode = [TRZoomTransitionImageHelper suggestedContentModeForImage:targetImage];
        actualImageSize = [TRZoomTransitionImageHelper presentedImageSize:targetImage forRect:originalFrame contentMode:contentMode];
    }
    else {
        actualImageSize = originalFrame.size;
    }
    
    scale = MAX(actualImageSize.width / viewFrame.size.width, actualImageSize.height / viewFrame.size.height);
    
    CGFloat tx = (CGRectGetMidX(originalFrame) - CGRectGetMidX(viewFrame))/scale;
    CGFloat ty = (CGRectGetMidY(originalFrame) - CGRectGetMidY(viewFrame))/scale;
    
    CGAffineTransform scaleTransform = CGAffineTransformScale(view.transform, scale, scale);
    CGAffineTransform transform = CGAffineTransformTranslate(scaleTransform, tx, ty);
    
    return transform;
}

+ (UIView*)createDecorationViewForRefView:(UIView*)referenceView originalFrame:(CGRect)originalFrame targetImage:(UIImage *)targetImage
{
    UIView *tmpView = [[UIView alloc] initWithFrame:referenceView.frame];
    
    UIView *blackView = [[UIView alloc] initWithFrame:referenceView.frame];
    UIColor *backgroundColour = referenceView.backgroundColor ?: [UIColor blackColor];
    blackView.backgroundColor = backgroundColour;
    blackView.alpha = 1.0;
    
    UIView *cellView;
    if (targetImage) {
        cellView = [[UIImageView alloc] initWithImage:targetImage];
        UIViewContentMode contentMode = [TRZoomTransitionImageHelper suggestedContentModeForImage:targetImage];
        cellView.contentMode = contentMode;
    }
    else {
        cellView = [referenceView resizableSnapshotViewFromRect:originalFrame afterScreenUpdates:NO withCapInsets:UIEdgeInsetsZero];
    }
    
    cellView.frame = originalFrame;
    cellView.clipsToBounds = YES;
    
    tmpView.translatesAutoresizingMaskIntoConstraints = NO;
    blackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [tmpView addSubview:blackView];
    [tmpView addSubview:cellView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(blackView, tmpView);
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[blackView]|" options:0 metrics:nil views:views];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[blackView]|" options:0 metrics:nil views:views];
    
    [tmpView addConstraints:horizontalConstraints];
    [tmpView addConstraints:verticalConstraints];
    
    return tmpView;
}

+ (void)configureDecorationView:(UIView*)tmpView inReferenceView:(UIView*)referenceView
{
    if(CGRectIsInfinite(referenceView.frame)) { return; }
    if(CGRectIsNull(referenceView.frame)) { return ; }
    
    [referenceView addSubview:tmpView];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(tmpView, referenceView);
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tmpView]|" options:0 metrics:nil views:views];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tmpView]|" options:0 metrics:nil views:views];
    
    [referenceView addConstraints:horizontalConstraints];
    [referenceView addConstraints:verticalConstraints];
    
    [tmpView layoutIfNeeded];
}

// Returning a default frame from the center of the View Controller's view
+ (CGRect)defaultTargetRectForRect:(CGRect)originalFrame
{
    CGFloat aspectRatio = originalFrame.size.height / originalFrame.size.width;
    CGSize newSize = CGSizeMake(originalFrame.size.width / 10.0, originalFrame.size.width*aspectRatio / 10.0);
    CGFloat originX = CGRectGetMidX(originalFrame) - (newSize.width/2.0);
    CGFloat originY = CGRectGetMidY(originalFrame) - (newSize.height/2.0);
    
    return CGRectMake(originX, originY, newSize.width, newSize.height);
}

@end
