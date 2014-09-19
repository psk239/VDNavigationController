//
//  VDViewController.m
//  VDNavigationController
//
//  Created by Paul Kim on 09/18/2014.
//  Copyright (c) 2014 Paul Kim. All rights reserved.
//

#import "VDExampleDrawerController.h"
#import <VDNavigationController/VDNavigationController.h>
#import "VDSecondViewController.h"
#import "VDThirdViewController.h"

@interface VDExampleDrawerController () <VDNavigationControllerDelegate>

@end

@implementation VDExampleDrawerController

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
    VDSecondViewController *secondViewController = [[VDSecondViewController alloc] init];
    [[self vdNavController] switchToViewController:secondViewController animated:YES];
}

- (void)thirdVCBtnPressed:(id)sender {
    VDThirdViewController *thirdViewController = [[VDThirdViewController alloc] init];
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
