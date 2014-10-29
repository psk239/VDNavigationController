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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Drawer";
    
    UIButton *secondVCBtn = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 60.0f, 100.0f, 100.0f)];
    secondVCBtn.backgroundColor = [UIColor blueColor];
    secondVCBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [secondVCBtn addTarget:self action:@selector(secondVCBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [secondVCBtn setTitle:@"Second VC" forState:UIControlStateNormal];
    
    UIButton *thirdVCBtn = [[UIButton alloc] initWithFrame:CGRectMake(180.0f, 60.0f, 100.0f, 100.0f)];
    thirdVCBtn.backgroundColor = [UIColor redColor];
    [thirdVCBtn addTarget:self action:@selector(thirdVCBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    thirdVCBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [thirdVCBtn setTitle:@"Third VC" forState:UIControlStateNormal];
    
    UIButton *modalVCBtn = [[UIButton alloc] initWithFrame:CGRectMake(10.0f, 180.0f, 100.0f, 100.0f)];
    modalVCBtn.backgroundColor = [UIColor redColor];
    [modalVCBtn addTarget:self action:@selector(modalVCBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    modalVCBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [modalVCBtn setTitle:@"Modal VC" forState:UIControlStateNormal];
    
    [self.view addSubview:secondVCBtn];
    [self.view addSubview:thirdVCBtn];
    [self.view addSubview:modalVCBtn];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondVCBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:10.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdVCBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:secondVCBtn attribute:NSLayoutAttributeRight multiplier:1.0f constant:10.0f]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:modalVCBtn attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:secondVCBtn attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondVCBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.0f constant:100.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdVCBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.0f constant:100.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:modalVCBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.0f constant:100.0f]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:secondVCBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.0f constant:100.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:thirdVCBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.0f constant:100.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:modalVCBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.0f constant:100.0f]];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self.vdNavController action:@selector(menuButtonPressed:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Push VC" style:UIBarButtonItemStylePlain target:self action:@selector(pushVCButtonPressed:)];
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

- (void)pushVCButtonPressed:(id)sender {
    UIViewController *tempViewController = [[UIViewController alloc] init];
    tempViewController.view.backgroundColor = [UIColor orangeColor];
    
    UIButton *popWithNoAnimateButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tempViewController.view.bounds.size.width * 0.8f, 200.0f)];
    popWithNoAnimateButton.center = tempViewController.view.center;
    [popWithNoAnimateButton setTitle:@"Pop with no animation" forState:UIControlStateNormal];
    [popWithNoAnimateButton addTarget:self action:@selector(popWithoutAnimation:) forControlEvents:UIControlEventTouchUpInside];
    [tempViewController.view addSubview:popWithNoAnimateButton];
    [self.navigationController pushViewController:tempViewController animated:YES];
}

- (void)popWithoutAnimation:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

@end
