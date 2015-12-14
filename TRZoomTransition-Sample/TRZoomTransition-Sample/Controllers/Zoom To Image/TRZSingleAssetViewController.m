//
//  TRZSingleAssetViewController.m
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

#import "TRZSingleAssetViewController.h"

//#import "TRZNavigationController.h"

#import <TRTransitions/TRTransition.h>
#import <TRTransitions/TRTransitionConfiguration+ZoomTransition.h>

@interface TRZSingleAssetViewController ()

@property (copy, nonatomic) NSString *transitionIdentifier;

@end

@implementation TRZSingleAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView.image = self.transitionConfiguration.targetImage;

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TRTransitionViewControllerProtocol

- (void)prepareTransition:(TRTransition *)transition
{
    transition.interactiveController = self.interactiveController;
    transition.configuration = self.transitionConfiguration;
}

@end
