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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"Navigation controller = %@", self.navigationController);
    
    if (!self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(menuButtonPressed:)];
    }

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

- (UICollectionViewCell *)vdNavigationController:(VDCollectionMenuController *)vdController cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = (CollectionViewCell *)[vdController dequeueReusableCellForIdentifier:ReuseCellIdentifier forIndexPath:indexPath];
    cell.titleLabel.text = @"Cell";
    return cell;
}

- (UIViewController *)vdNavigationController:(VDCollectionMenuController *)vdController viewControllerAtIndex:(NSIndexPath *)indexPath {
    return nil;
}

@end
