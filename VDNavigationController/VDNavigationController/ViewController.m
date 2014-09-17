//
//  ViewController.m
//  VDNavigationController
//
//  Created by Paul Kim on 9/16/14.
//
//

#import "ViewController.h"
#import "CollectionViewCell.h"

NSString * const ReuseCellIdentifier = @"ReuseCellIdentifier";

@interface ViewController () <VDNavigationControllerDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = self;
    [self registerWithCollectionViewCellClass:[CollectionViewCell class] forReuseIdentifier:ReuseCellIdentifier];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - VDNavigationController Data Source Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)vdNavigationController:(VDNavigationController *)vdController cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[vdController dequeueReusableCellForIdentifier:ReuseCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = @"Cell";
    return cell;
}

- (UIViewController *)vdNavigationController:(VDNavigationController *)vdController viewControllerAtIndex:(NSIndexPath *)indexPath {
    return nil;
}

@end
