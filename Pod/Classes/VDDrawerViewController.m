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

- (NSArray*)leftBarButtonItems {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    return nil;
}

- (NSArray*)rightBarButtonItems {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    return nil;
}

@end
