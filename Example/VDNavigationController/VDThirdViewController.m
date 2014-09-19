//
//  VDThirdViewController.m
//  VDNavigationController
//
//  Created by Paul Kim on 9/18/14.
//  Copyright (c) 2014 Paul Kim. All rights reserved.
//

#import "VDThirdViewController.h"

@interface VDThirdViewController ()

@end

@implementation VDThirdViewController

- (void)loadView {
    [super loadView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Third View Controller";
    self.view.backgroundColor = [UIColor purpleColor];
    // Do any additional setup after loading the view.
    
    if (!self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(menuButtonPressed:)];
    }
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect rect = self.view.frame;
    rect.origin.y += 64.0f;
    self.view.frame = rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
