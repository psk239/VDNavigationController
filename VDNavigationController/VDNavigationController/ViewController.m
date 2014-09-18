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

@interface ViewController ()

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.navigationController action:@selector(menuButtonPressed:)];
    }
}

- (void)secondVCBtnPressed:(id)sender {
    NSLog(@"Second vc button pressed");
    SecondViewController *secondViewController = [[SecondViewController alloc] init];
    [[self vdNavController] switchToViewController:secondViewController];
}

- (void)thirdVCBtnPressed:(id)sender {
    NSLog(@"Third vc button pressed");
    ThirdViewController *thirdViewController = [[ThirdViewController alloc] init];
    [[self vdNavController] switchToViewController:thirdViewController];

}


@end
