//
//  VDSecondViewController.m
//  VDNavigationController
//
//  Created by Paul Kim on 9/18/14.
//  Copyright (c) 2014 Paul Kim. All rights reserved.
//

#import "VDSecondViewController.h"

@interface VDSecondViewController ()

@end

@implementation VDSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.title = @"Second View Controller";
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(menuButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(buttonPressed:)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonPressed:(id)sender {
    UIViewController *viewController = [[UIViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    viewController.view.backgroundColor = [UIColor redColor];
}

@end
