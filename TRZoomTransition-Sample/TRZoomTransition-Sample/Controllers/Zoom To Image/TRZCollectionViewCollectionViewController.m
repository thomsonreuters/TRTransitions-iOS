//
//  TRZCollectionViewCollectionViewController.m
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

#import "TRZCollectionViewCollectionViewController.h"

#import "TRZCollectionViewCell.h"
#import "TRZNavigationController.h"
#import "TRZSingleAssetViewController.h"

#import <TRTRansitions/TRTransitions.h>
#import <TRTransitions/TRTransitionConfiguration+ZoomTransition.h>

NSUInteger const kNumberOfImages = 7;
NSTimeInterval const kTransitionDuration = 0.5;

@interface TRZCollectionViewCollectionViewController ()

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) TRTransitionConfiguration *configuration;

@end

@implementation TRZCollectionViewCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:kNumberOfImages];
    for (int i=0; i<kNumberOfImages-1; i++) {
        NSString *name = [NSString stringWithFormat:@"m-%d", i];
        UIImage *image = [UIImage imageNamed:name];
        [array addObject:image];
    }
    
    self.images = array;
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"TRZCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Configure view
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.imageView.image = self.images[indexPath.item];
    
    return cell;
}

#pragma mark - TRTransitionViewControllerProtocol

- (void)prepareTransition:(TRTransition *)transition
{
    transition.configuration = self.configuration;
}

- (void)viewControllerWillBeginTransitioning
{
    // UICollectionViews are tricky. If you allow for different orientations and the cells of your UICollectionView resize according
    // to the different screen sizes, you may want to ensure the layout is updated before starting
    // the animated transition (jjramos 12.06.15)
    [self.view layoutIfNeeded];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *targetImage = self.images[indexPath.item];

    // Transition Configuration
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
    
    self.configuration = [[TRTransitionConfiguration alloc] initWithDuration:kTransitionDuration];
    self.configuration.targetImage = targetImage;
    self.configuration.targetRectBlock = targetRect;
    
    // Single Asset set up
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TRZSingleAssetViewController *singleAssetVC = [storyBoard instantiateViewControllerWithIdentifier:@"singleAsset"];
    singleAssetVC.transitionConfiguration = self.configuration;
    
    [self.navigationController pushViewController:singleAssetVC animated:YES];
}

@end
