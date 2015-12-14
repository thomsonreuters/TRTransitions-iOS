//
//  TRZViewController.m
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

#import "TRZViewController.h"

#import "TRZSettingsViewController.h"
#import "TRZSecondaryNavigationController.h"

#import <TRTransitions/TRSegueTransition.h>
#import <TRTransitions/TRZoomInRectForwardTransition.h>
#import <TRTransitions/TRTransitionConfiguration+ZoomTransition.h>
#import <TRTransitions/TRZoomInRectBackwardTransition.h>

@interface TRZViewController ()

@property (strong, nonatomic) TRTransitionConfiguration *transitionConfiguration;
@property (strong, nonatomic) id<TRTransitionProtocol> forwardTransitionAgent;
@property (strong, nonatomic) id<TRTransitionProtocol> backwardTransitionAgent;
@property (assign, nonatomic) TRTransitionClass transitionClass;
@property (weak, nonatomic) IBOutlet UIButton *segueButton;

@end

@implementation TRZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.forwardTransitionAgent = [[TRZoomInRectForwardTransition alloc] initWithTransitionMode:TRZoomInRectTransitionModeDifferentContent transitionClass:TRTransitionClassSegue];
    self.backwardTransitionAgent = [[TRZoomInRectBackwardTransition alloc] initWithTransitionMode:TRZoomInRectTransitionModeDifferentContent];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - TRTransitionViewControllerProtocol

- (void)prepareTransition:(TRTransition *)transition
{
    transition.configuration = self.transitionConfiguration;
}

#pragma mark - IBAction

- (IBAction)transition:(UIButton *)sender
{
    // Transition configuration
    CGRect(^rect)(void) = ^{
        return sender.frame;
    };

    self.transitionConfiguration = [[TRTransitionConfiguration alloc] initWithDuration:0.5];
    self.transitionConfiguration.targetRectBlock = rect;
    
    TRZSettingsViewController *viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Settings"];
    viewController.transitionConfiguration = self.transitionConfiguration;
    viewController.transitionClass = TRTransitionClassNavigationTransition;

    self.transitionClass = TRTransitionClassNavigationTransition;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    if ([segue.identifier isEqualToString:@"zoomInRect"]) {
        TRSegueTransition *transition = (TRSegueTransition *)segue;
        transition.transitionAgent = self.forwardTransitionAgent;
        
        CGRect(^rect)(void) = ^{
            return sender.frame;
        };
        
        self.transitionConfiguration = [[TRTransitionConfiguration alloc] initWithDuration:0.5];
        self.transitionConfiguration.targetRectBlock = rect;
        
        __weak typeof(self) weakSelf = self;
        self.transitionConfiguration.completionHandler = ^(BOOL finished){
            if (finished) {
                [weakSelf.navigationController presentViewController:segue.destinationViewController animated:NO completion:nil];
            }
            return YES;
        };
        
        self.transitionClass = TRTransitionClassSegue;
        
        transition.configuration = self.transitionConfiguration;
        [(TRZSecondaryNavigationController *)segue.destinationViewController setConfiguration:self.transitionConfiguration];
        [(TRZSecondaryNavigationController *)segue.destinationViewController setTransitionClass:TRTransitionClassSegue];
        [(TRZSecondaryNavigationController *)segue.destinationViewController setSegueIdentifier:@"dismissSettingsSegue"];
    }
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier
{
    if ([identifier isEqualToString:@"dismissSettingsSegue"]) {
        TRTransitionConfiguration *backTransitionConfiguration = [[TRTransitionConfiguration alloc] initWithDuration:0.5];
        backTransitionConfiguration.targetRectBlock = self.transitionConfiguration.targetRectBlock;
        
        __weak typeof(UIViewController *) weakVC = fromViewController;
        backTransitionConfiguration.completionHandler = ^(BOOL finished){
            if (finished) {
                [weakVC dismissViewControllerAnimated:NO completion:nil];
            }
            return YES;
        };
        ///////////////////////////////// IMPORTANT /////////////////////////////////
        // For this kind of segue, we must create it programmatically specifying   //
        // the source and destination view controllers                             //
        /////////////////////////////////////////////////////////////////////////////
        fromViewController = ([fromViewController respondsToSelector:@selector(animatedViewController)]) ? [(id<TRTransitionViewControllerProtocol>)fromViewController animatedViewController] : fromViewController;
        toViewController = ([toViewController respondsToSelector:@selector(animatedViewController)]) ? [(id<TRTransitionViewControllerProtocol>)toViewController animatedViewController] : toViewController;
        TRSegueTransition *backTransition = [[TRSegueTransition alloc] initWithIdentifier:@"dismissSettingsSegue" source:fromViewController destination:toViewController configuration:backTransitionConfiguration transitionAgent:self.backwardTransitionAgent];
        return backTransition;
    }
    
    return [super segueForUnwindingToViewController:toViewController
                                 fromViewController:fromViewController
                                         identifier:identifier];
}

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
{
    return YES;
}

// Necessary to add the hook in the Storyboard (even if it has a blank implementation)
- (IBAction)returnFromSegue:(UIStoryboardSegue *)sender
{
    
}

#pragma mark - TRTransitionViewControllerProtocol

- (UIViewController *)animatedViewController
{
    return (self.transitionClass == TRTransitionClassSegue) ? self.navigationController : self;
}

@end
