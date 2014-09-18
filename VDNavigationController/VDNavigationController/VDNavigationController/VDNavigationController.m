//
//  VDNavigationController.m
//  VDNavigationController
//
//  Created by Paul Kim on 9/17/14.
//
//

#import "VDNavigationController.h"
#import "VDDrawerViewController.h"

@interface VDNavigationController () <UINavigationControllerDelegate>
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) NSString *cachedTitle;
@property (nonatomic, strong) NSArray *cachedRightBarButtonItems;
@property (nonatomic, strong) UIView *cachedSuperView;

@end

@implementation VDNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super initWithRootViewController:rootViewController]) {
        _rootViewController = rootViewController;
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
    return self.rootViewController.view.frame.origin.y >= [UIScreen mainScreen].bounds.size.height;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Mutators
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setSelectedIndex:(NSIndexPath *)selectedIndex {
    _selectedIndex = selectedIndex;
    [self showMenuAnimated:YES];
}

- (void)setDrawerController:(VDDrawerViewController *)drawerController {
    _drawerController = drawerController;
    _drawerController.vdNavController = self;
    
    self.drawerController.view.frame = [self presentedViewFrame];
    [self.view addSubview:self.drawerController.view];
    [self.view sendSubviewToBack:self.drawerController.view];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)switchToViewController:(UIViewController*)viewController animated:(BOOL)animated {
    if (viewController) {
        [self.rootViewController.view removeFromSuperview];
        self.viewControllers = @[viewController];
        self.rootViewController = viewController;
        
        [self.view addSubview:self.drawerController.view];
        [self.view sendSubviewToBack:self.drawerController.view];
        
        self.rootViewController.view.frame = [self dismissedViewFrame];

        [self hideMenuAnimated:animated];
    }
}

- (IBAction)menuButtonPressed:(id)sender {
    NSLog(@"View Controllers = %@", [self  viewControllers]);
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
        [UIView animateWithDuration:0.25 animations:^{
            self.rootViewController.view.frame = [self dismissedViewFrame];
        } completion:^(BOOL finished) {
            self.cachedSuperView = self.rootViewController.view.superview;
            [self.cachedSuperView addSubview:self.drawerController.view];
        
            [self.rootViewController.view removeFromSuperview];
        }];
    }
}

- (void)hideMenuAnimated:(BOOL)animated {
    
    if ([self baseViewControllerVisible]) {

        [self.cachedSuperView addSubview:self.rootViewController.view];
        [UIView animateWithDuration:0.25f animations:^{
            self.rootViewController.view.frame = [self presentedViewFrame];
        } completion:^(BOOL finished) {
            [self.view addSubview:self.drawerController.view];
            [self.view sendSubviewToBack:self.drawerController.view];

        }];
    }
}

@end
