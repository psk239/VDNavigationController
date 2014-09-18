//
//  ThirdViewController.m
//  VDNavigationController
//
//  Created by Paul Kim on 9/17/14.
//
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)loadView {
    [super loadView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Third View Controller";
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.

    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    NSLog(@"nav controller = %@", self.navigationController.navigationBar);
    NSLog(@"nav bar hidden = %d", self.navigationController.navigationBarHidden);
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
