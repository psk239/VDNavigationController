//
//  VDDeletePreviousViewController.m
//  VDNavigationController
//
//  Created by Paul Kim on 10/24/14.
//  Copyright (c) 2014 Paul Kim. All rights reserved.
//

#import "VDDeletePreviousViewController.h"
#import "VDSkipViewController.h"

@interface VDDeletePreviousViewController ()

@end

@implementation VDDeletePreviousViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *deletePreviousSkipViewController = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 100.0f)];
    deletePreviousSkipViewController.center = self.view.center;
    deletePreviousSkipViewController.backgroundColor = [UIColor greenColor];
    [deletePreviousSkipViewController setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deletePreviousSkipViewController setTitle:@"Delete previous skip view controller" forState:UIControlStateNormal];
    [deletePreviousSkipViewController addTarget:self action:@selector(deletePreviousViewControllerPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deletePreviousSkipViewController];
}

- (void)deletePreviousViewControllerPressed:(id)sender {
    
    if (self.navigationController) {
        
        VDSkipViewController *skipController = nil;
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([[controller class] isSubclassOfClass:[VDSkipViewController class]]) {
                skipController = (VDSkipViewController*)controller;
                
                NSMutableArray *mutableControllers = self.navigationController.viewControllers.mutableCopy;
                [mutableControllers removeObject:skipController];
                self.navigationController.viewControllers = mutableControllers;
                break;
            }
        }
    }
}


@end
