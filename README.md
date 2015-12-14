# TRTransitions

This library provides an easy way to use in your application one of the provided custom animated transitions and also extend them to create your own.

There are 2 custom animated transitions provided in this library:
* `TRZoomInRectForwardTransition`. The animation creates a _zoom in effect_ similar to the one used by iOS when opening an application from the Home Screen. You can specify the frame where you want the zoom in to happen or by default it would pick up a frame in the centre of the `UIViewController`'s view.
* `TRZoomInRectBackwardTransition`. The supplementary effect of the one depicted above.

If you want to create your own and add it to the library, all you need to do is make it conform to the `TRTransitionProtocol`.

# Where can I use them?
The custom transitions provided or any extension can be used both as:
1. `UIViewControllerAnimatedTransitioning` when navigating between 2 UIViewControllers. In this case, you need to use a `TRTransition` object and set the `id<TRTransitionProtocol> transitionAgent` of your choice.
2. Custom `UIStoryboardSegue`. In this case, you need to use a `TRSegueTransition` object and also set the `id<TRTransitionProtocol> transitionAgent` of your choice.

# How to use them
## As custom navigation transitions
There is an utility class provided called `TRTransitionRegistry` that you may want to use in order to facilitate the task of picking the right custom animated transition, if any, when navigating between 2 UIViewControllers.
In order to **register your transitions in `TRTransitionRegistry`** you need:
1. The `TRTransition` object that you want to use. For every `TRTransition` object you need to provide 2 things:
    1. `TRTransitionConfiguration` object. It can be provided when the transition is initialized or right before the transition is about to happen.
    2. The actual `id<TRTransitionProtocol> agent` that implements the custom animation.
2. A `TRTransitionIdentifer` (NSString). `TRTransitionRegistry` provides a couple of helper methods to create that. If you just pass the 'to' `UIViewController`, a wildcard will be used in the identifier to indicate that any navigation to that view controller will use the registered `TRTransition` (same applies for the 'from').

```objc
// 1. Using a TRZoomInRectForward transition
// 2. Configuration object will be provided later
// 3. Using it as a custom navigation transition
// 4. Zoom in will be performed on similar content
TRZoomInRectForwardTransition *forwardSameTransitionAgent = [[TRZoomInRectForwardTransition alloc] initWithTransitionMode:TRZoomInRectTransitionModeSameContent transitionClass:TRTransitionClassNavigationTransition];
TRTransition *forwardSameTransition = [[TRTransition alloc] initWithConfiguration:nil transitionAgent:forwardSameTransitionAgent];

// Create the transition identifier. In this case, the identifier represents ANY 
// transition where the toViewController is a TRZSingleAssetViewController
NSString *saForwardTransitionIdentifier = [TRTransitionRegistry createTransitionIdentifier:nil toViewControllerClass:[TRZSingleAssetViewController class]];
            
// Register the transition
[[TRTransitionRegistry sharedInstance] registerTransition:forwardSameTransition withIdentifier:saForwardTransitionIdentifier];
```

## Setup your `UINavigationController` (if you are using any)
`TRTransitionRegistry` conforms to `UINavigationControllerDelegate`. You can either set it as the delegate of your `UINavigationController` or forward the calls to it.

## Preparing the transitions
1. `TRTransitionConfiguration`. All `TRTransition` objects need a configuration object that at the very least needs to provide the _transition duration_. If you are using any of the _ZoomTransitions_ you may want to provide:
    1. *targetRect (optional).* The frame in ot fromViewController where the transition should zoom into. If none is provided, it would create a default frame in the middle of fromViewController's view. It has to be wrapped in a block.
    2. *targetImage (optional).* If you are zooming into an image, provide it here so it would be used in the transition instead of a view's snapshot that would look pixelated when scaling it.
2. You can update the `TRTransition` with the configuration object on `prepareTransition:` or pass the configuration object when you initialize the transition if you have all the information at that stage.
3. If you are using any of the provided _ZoomTransitions_ remember to import `TRTransitionConfiguration+ZoomTransition` to make your life easier setting all the properties.

### EXAMPLE: Using the zoom in transition on a `UICollectionViewCell` that contains an image
```objc
// Preparing all the information needed when the user taps on a cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Get the image to zoom in
    UIImage *targetImage = self.images[indexPath.item];

    // Prepare the TRTransitionConfiguration Object
    // 1. Provide the frame where you want the zoom in to occur
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect frame;
    if (!attributes || CGRectIsEmpty(attributes.frame) ) {
        frame = [[self.collectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]] frame];
    }
    else {
        frame = attributes.frame;
    }
    
    frame = [self.view convertRect:frame fromView:self.collectionView];
    [self.collectionView scrollRectToVisible:frame animated:NO];
    
    CGRect (^targetRect)(void) = ^{
        return frame;
    };
    
    // 2. Duration of the transition
    self.configuration = [[TRTransitionConfiguration alloc] initWithDuration:0.3];
    // 3. Since it is going to zoom in into an image, provide the original image
    // as well so it doesn't look pixelated during the animation
    self.configuration.targetImage = targetImage;
    self.configuration.targetRectBlock = targetRect;
    
    // Create the toViewController
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TRZSingleAssetViewController *singleAssetVC = [storyBoard instantiateViewControllerWithIdentifier:@"singleAsset"];
    singleAssetVC.transitionConfiguration = self.configuration;
    
    // Pushing the `UIViewController` on the navigation stack.
    // Given the registration steps provided before, the registered
    // TRZoomInRectForwardTransition object will be used to animate the transition
    [self.navigationController pushViewController:singleAssetVC animated:YES];
}
```
```objc
// Implement prepareTransition: to add any necessary information to the 
// TRTransition object
#pragma mark - TRTransitionViewControllerProtocol
- (void)prepareTransition:(TRTransition *)transition
{
    transition.configuration = self.configuration;
}
```

### Make your transitions interactive
If you want your transitions to be driven by a `UIPinchGestureRecognizer`, all you need to do is to have your `UIViewController` inherit from `TRTransitionInteractiveViewController` (see `TRZSingleAssetViewController` as an example in the demo app). Pretty easy!

## As Custom Segues
Any Custom Transition (that conforms to `TRTransitionProtocol`) can also be used as a Custom Segue. The preparation steps are similar to the ones depicted before, the only difference is where the information is provided.
### From `TRZViewController` in the demo app
Setup the transition configuration information in `prepareForSegue:`
```objc
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    if ([segue.identifier isEqualToString:@"zoomInRect"]) {
        TRSegueTransition *transition = (TRSegueTransition *)segue;
        // self.forwardTransitionAgent has been defined earlier. 
        // The definition could be the same used for the navigation transition 
        // in the previous section but changing the transitionClass
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
```
### The Unwind Segue
There is a very good post [here](http://www.appcoda.com/custom-segue-animations/) by Gabriel Theodoropoulos describing everything about Custom Segues including the Unwind Segue. These are the most important bits of the implementation included in the demo app.
```objc
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

        fromViewController = ([fromViewController respondsToSelector:@selector(animatedViewController)]) ? [(id<TRTransitionViewControllerProtocol>)fromViewController animatedViewController] : fromViewController;
        toViewController = ([toViewController respondsToSelector:@selector(animatedViewController)]) ? [(id<TRTransitionViewControllerProtocol>)toViewController animatedViewController] : toViewController;
        TRSegueTransition *backTransition = [[TRSegueTransition alloc] initWithIdentifier:@"dismissSettingsSegue" source:fromViewController destination:toViewController configuration:backTransitionConfiguration transitionAgent:self.backwardTransitionAgent];
        return backTransition;
    }
    
    return [super segueForUnwindingToViewController:toViewController
                                 fromViewController:fromViewController
                                         identifier:identifier];
}
```
```objc
- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender
{
    return YES;
}
```
```objc
// Necessary to add the hook in the Storyboard (even if it has a blank implementation)
- (IBAction)returnFromSegue:(UIStoryboardSegue *)sender
{
}
```

## Want to provide your own custom transitions?
Nice idea. Just make it your class conform to `TRTransitionProtocol` and it will be available to be used as an agent by both `TRTransition` and `TRSegueTransition` depending whether you want the animation to occur.

**N.B:** Remember to call `viewControllerWillBeginTransitioning`, `viewControllerIsTransitioning` and `viewControllerDidEndTransitioning` if they are implemented on your view controllers, so you give them the chance to perform any necessary update.

# Contribution
To contribute to this project, please read and sign one of the contribution agreements included in the repository.

TRTransitions-iOS Entity Contributor License Agreement v1.1

TRTransitions-iOS Individual Contributor License Agreement v1

# Acknowledgements
Images used in the sample project have been downloaded from [Pixabay](https://pixabay.com/) who provides those images [under Creative Commons CCO](https://pixabay.com/es/service/terms/).

# Contact
Juanjo Ramos - General, iOS - jjramos.developer@gmail.com

Francisco Estevez - Governance - francisco.estevezgarcia@thomsonreuters.com

Francisco M. Pereira - iOS - francisco.pereira@thomsonreuters.com

# License
Copyright 2015 Thomson Reuters

The Apache Software License, Version 2.0

See LICENSE.md