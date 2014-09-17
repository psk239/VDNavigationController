//
//  VDNavigationController.m
//  VDNavigationController
//
//  Created by Paul Kim on 9/17/14.
//
//

#import "VDNavigationController.h"

@interface VDNavigationController ()

@end

@implementation VDNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        _baseViewController = rootViewController;
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View Lifecycle Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Accessors
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGRect)presentedViewFrame {
    CGRect presentedView = self.view.bounds;
    
    if (!self.navigationBarHidden) {
        CGFloat navHeight = self.navigationBar.frame.size.height;
        presentedView.origin.y += navHeight;
        presentedView.size.height -= navHeight;
        
        if (![UIApplication sharedApplication].statusBarHidden) {
            CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            presentedView.origin.y += statusBarHeight;
            presentedView.size.height -= statusBarHeight;
        }
        
    }
    return presentedView;
}

- (CGRect)dismissedViewFrame {
    CGRect dismissedFrame = self.view.bounds;
    dismissedFrame.origin.y += dismissedFrame.size.height;
    return dismissedFrame;
}

- (BOOL)baseViewControllerVisible {
    return [self.childViewControllers count] == 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Mutators
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setSelectedIndex:(NSIndexPath *)selectedIndex {
    _selectedIndex = selectedIndex;
    [self showMenuAnimated:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)menuButtonPressed:(id)sender {
    if ([self baseViewControllerVisible]) {
        [self hideMenuAnimated:YES];
    } else {
        [self showMenuAnimated:YES];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Display Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)showMenuAnimated:(BOOL)animated {
    
    if (![self baseViewControllerVisible]) {
        
        UIViewController *childViewController = [self.childViewControllers lastObject];
        if (childViewController) {
            NSTimeInterval duration = (animated) ? 0.25f : 0.0f;
            
            [childViewController willMoveToParentViewController:nil];
            childViewController.view.frame = [self presentedViewFrame];

            [UIView animateWithDuration:duration animations:^{
                childViewController.view.frame = [self dismissedViewFrame];
            } completion:^(BOOL finished) {
                [childViewController removeFromParentViewController];
            }];
        }
    }
}

- (void)hideMenuAnimated:(BOOL)animated {
    
    if ([self baseViewControllerVisible]) {
        UIViewController *controller = [self.vdNavigationControllerDelegate vdNavigationController:self controllerAtIndex:self.selectedIndex];
        
        [self addChildViewController:controller];
        controller.view.frame = [self dismissedViewFrame];
        [self.view addSubview:controller.view];

        NSTimeInterval duration = (animated) ? 0.25f : 0.0f;
        
        [UIView animateWithDuration:duration animations:^{
            controller.view.frame = [self presentedViewFrame];
        } completion:^(BOOL finished) {
            [controller didMoveToParentViewController:self];
        }];
    }
}

@end
