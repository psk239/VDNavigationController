//
//  VDSkipViewController.m
//  VDNavigationController
//
//  Created by Paul Kim on 10/24/14.
//  Copyright (c) 2014 Paul Kim. All rights reserved.
//

#import "VDSkipViewController.h"
#import "VDDeletePreviousViewController.h"

@interface VDSkipViewController () <UINavigationControllerDelegate>

@end

@implementation VDSkipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Skip";
    self.view.backgroundColor = [UIColor redColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(buttonPressed:)];
    self.navigationController.delegate = self;
}

- (void)buttonPressed:(id)sender {
    VDDeletePreviousViewController *viewController = [[VDDeletePreviousViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
