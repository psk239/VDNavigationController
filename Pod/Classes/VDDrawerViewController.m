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

- (UINavigationController*)navigationController {
    
    if (self.vdNavController) {
        return self.vdNavController;
    }
    
    return [super navigationController];
}

@end
