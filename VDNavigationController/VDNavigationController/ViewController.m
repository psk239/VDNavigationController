//
//  ViewController.m
//  VDNavigationController
//
//  Created by Paul Kim on 9/16/14.
//
//

#import "ViewController.h"
#import "VDNavigationController.h"
#import "CollectionViewCell.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

NSString * const ReuseCellIdentifier = @"ReuseCellIdentifier";

@interface ViewController () <VDNavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *secondVCBtn = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 60.0f, 100.0f, 100.0f)];
    secondVCBtn.backgroundColor = [UIColor blueColor];
    [secondVCBtn addTarget:self action:@selector(secondVCBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [secondVCBtn setTitle:@"Second VC" forState:UIControlStateNormal];
    
    UIButton *thirdVCBtn = [[UIButton alloc] initWithFrame:CGRectMake(180.0f, 60.0f, 100.0f, 100.0f)];
    thirdVCBtn.backgroundColor = [UIColor redColor];
    [thirdVCBtn addTarget:self action:@selector(thirdVCBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [thirdVCBtn setTitle:@"Third VC" forState:UIControlStateNormal];

    [self.view addSubview:secondVCBtn];
    [self.view addSubview:thirdVCBtn];
    
    self.vdNavController.vdNavigationControllerDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(menuButtonPressed:)];
    }
}

- (void)secondVCBtnPressed:(id)sender {
    SecondViewController *secondViewController = [[SecondViewController alloc] init];
    [[self vdNavController] switchToViewController:secondViewController animated:YES];
}

- (void)thirdVCBtnPressed:(id)sender {
    ThirdViewController *thirdViewController = [[ThirdViewController alloc] init];
    [[self vdNavController] switchToViewController:thirdViewController animated:YES];

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - VDNavigationDelegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)vdNavigationControllerWillPresentDrawer:(VDNavigationController *)navController {
    
    for (UIView *view in self.view.subviews) {
        if ([[view class] isSubclassOfClass:[UIButton class]]) {
            view.alpha = 0.0f;
        }
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        for (UIView *view in self.view.subviews) {
            if ([[view class] isSubclassOfClass:[UIButton class]]) {
                view.alpha = 1.0f;
            }
        }
    }];
}

@end
