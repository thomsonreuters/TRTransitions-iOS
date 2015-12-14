//
//  TRSegueTransition.m
//  TRTransitions
//
//  Created by Juanjo Ramos Rodriguez on 12/12/15.
//  Copyright © 2015 Thomson Reuters. All rights reserved.
//

#import "TRSegueTransition.h"
#import "TRTransitionConfiguration.h"
#import "TRTransitionContext.h"
#import "TRTransitionProtocol.h"

@implementation TRSegueTransition

- (instancetype)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination configuration:(TRTransitionConfiguration *)configuration transitionAgent:(id<TRTransitionProtocol>)transitionAgent
{
    if (self = [super initWithIdentifier:identifier source:source destination:destination]) {
        self.transitionAgent = transitionAgent;
        self.configuration = configuration;
    }
    return self;
}

#pragma mark - UIStoryboardSegue

- (void)perform
{
    TRTransitionContext *context = [[TRTransitionContext alloc] initWithFromVC:self.sourceViewController toVC:self.destinationViewController];
    
    [self.transitionAgent performTransitionWithContext:context configuration:self.configuration completionHandler:self.configuration.completionHandler];
}

@end
