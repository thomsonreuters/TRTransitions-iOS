//
//  TRZTableViewController.m
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

#import "TRZSettingsViewController.h"

#import <TRTransitions/TRTransitionConfiguration.h>

@interface TRZSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TRZSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self _configureViewControllerForTransitionClass:self.transitionClass];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - TRTransitionViewControllerProtocol

- (UIViewController *)animatedViewController
{
    return (self.transitionClass == TRTransitionClassSegue) ? self.navigationController : self;
}

- (void)prepareTransition:(TRTransition *)transition
{
    transition.interactiveController = self.interactiveController;
    transition.configuration = self.transitionConfiguration;
}

#pragma mark - Private Methods

- (void)_dismiss
{
    [self performSegueWithIdentifier:self.segueIdentifier sender:self];
}

- (void)_configureViewControllerForTransitionClass:(TRTransitionClass)transitionClass
{
    if (transitionClass == TRTransitionClassSegue) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                                              target:self
                                                                                              action:@selector(_dismiss)];
    }
    else if (transitionClass == TRTransitionClassNavigationTransition) {
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Option %ld", (long)indexPath.row];
    
    return cell;
}

@end
