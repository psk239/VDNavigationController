//
//  VDDrawerViewController.m
//  VDNavigationController
//
//  Created by Paul Kim on 9/18/14.
//
//

#import "VDDrawerViewController.h"
#import "VDNavigationController.h"

@interface VDDrawerViewController ()

@end

@implementation VDDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UINavigationController*)navigationController {
    
    if (self.vdNavController) {
        return self.vdNavController;
    }
    
    return [super navigationController];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
