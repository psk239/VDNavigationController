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
#import "VDModalViewController.h"

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
    
    UIButton *modalVCBtn = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 180.0f, 100.0f, 100.0f)];
    modalVCBtn.backgroundColor = [UIColor redColor];
    [modalVCBtn addTarget:self action:@selector(modalVCBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [modalVCBtn setTitle:@"Modal VC" forState:UIControlStateNormal];
    
    [self.view addSubview:secondVCBtn];
    [self.view addSubview:thirdVCBtn];
    [self.view addSubview:modalVCBtn];
    self.vdNavController.vdNavigationControllerDelegate = self;
}

- (void)secondVCBtnPressed:(id)sender {
    VDSecondViewController *secondViewController = [[VDSecondViewController alloc] init];
    [[self vdNavController] switchToViewController:secondViewController animated:YES];
}

- (void)thirdVCBtnPressed:(id)sender {
    VDThirdViewController *thirdViewController = [[VDThirdViewController alloc] init];
    [[self vdNavController] switchToViewController:thirdViewController animated:YES];
}

- (void)modalVCBtnPressed:(id)sender {
    VDModalViewController *modalVC = [[VDModalViewController alloc] init];
    [[self vdNavController] presentViewController:modalVC animated:YES completion:nil];
}

- (NSArray*)leftBarButtonItems {
    return @[[[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(menuButtonPressed:)]];
}

- (NSArray*)rightBarButtonItems {
    return nil;
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
