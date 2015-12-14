//
//  TRInteractiveViewController.m
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

#import "TRTransitionInteractiveViewController.h"

@interface TRTransitionInteractiveViewController ()

@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactiveTransition;

@end

@implementation TRTransitionInteractiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createPinchGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TRTransitionInteractiveViewControllerProtocol

- (id<UIViewControllerInteractiveTransitioning>)interactiveController
{
    return self.interactiveTransition;
}

#pragma mark - Private Methods

- (void)_createPinchGestureRecognizer
{
    UIPinchGestureRecognizer *gestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(_handlePinch:)];
    gestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)_handlePinch:(UIPinchGestureRecognizer*)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            [self _pinchDidBegin:gestureRecognizer];
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self _pinchDidChange:gestureRecognizer];
            
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded: {
            
            [self _pinchDidFinish:gestureRecognizer];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)_pinchDidBegin:(UIPinchGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.scale < 1.0) {
        
        self.interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)_pinchDidChange:(UIPinchGestureRecognizer *)gestureRecognizer
{
    [self.interactiveTransition updateInteractiveTransition:1 - gestureRecognizer.scale];
}

- (void)_pinchDidFinish:(UIPinchGestureRecognizer *)gestureRecognizer
{
    self.interactiveTransition.completionSpeed = MIN(MAX(fabs(gestureRecognizer.velocity), 0.1), 1.5);
    
    if (gestureRecognizer.scale <= 0.6) {
        [self.interactiveTransition finishInteractiveTransition];
    }
    else {
        [self.interactiveTransition cancelInteractiveTransition];
    }
    
    self.interactiveTransition = nil;
}

@end
