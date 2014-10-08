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
@property (nonatomic) BOOL isAnimating;
@property (nonatomic) VDNavigationControllerPresentationState pendingPresentationState;
@end

@implementation VDNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController])
    {
        _rootViewController = rootViewController;
        
        self.pendingPresentationState = VDNavigationControllerPresentationStateNone;
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View Lifecycle Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)loadView
{
    [super loadView];
    self.isAnimating = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.pendingPresentationState == VDNavigationControllerPresentationStateOpen) {
        [self showMenuAnimated:NO];
        self.pendingPresentationState = VDNavigationControllerPresentationStateNone;
    } else if (self.pendingPresentationState == VDNavigationControllerPresentationStateClosed) {
        [self hideMenuAnimated:NO];
        self.pendingPresentationState = VDNavigationControllerPresentationStateNone;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Accessors
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (CGRect)presentedViewFrame
{
    CGRect presentedView = self.view.bounds;
    
    if (!self.navigationBarHidden)
    {
        CGFloat navHeight = self.navigationBar.frame.size.height;
        presentedView.origin.y += navHeight;
        presentedView.size.height -= navHeight;
        
        if (![UIApplication sharedApplication].statusBarHidden)
        {
            CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            presentedView.origin.y += statusBarHeight;
            presentedView.size.height -= statusBarHeight;
        }
        
    }
    return presentedView;
}

- (CGRect)dismissedViewFrame
{
    CGRect dismissedFrame = self.view.bounds;
    dismissedFrame.origin.y += dismissedFrame.size.height;
    return dismissedFrame;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Mutators
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setDrawerController:(VDDrawerViewController *)drawerController
{
    _drawerController = drawerController;
    _drawerController.vdNavController = self;
    
    self.drawerController.view.frame = [self presentedViewFrame];
    [self.view addSubview:self.drawerController.view];
    [self.view sendSubviewToBack:self.drawerController.view];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)switchToViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if (viewController)
    {
        [self.rootViewController.view removeFromSuperview];
        self.viewControllers = @[viewController];
        self.rootViewController = viewController;
        
        [self.view addSubview:self.drawerController.view];
        [self.view sendSubviewToBack:self.drawerController.view];
        
        self.rootViewController.view.frame = [self dismissedViewFrame];
        
        [self hideMenuAnimated:animated];
    }
}

- (IBAction)menuButtonPressed:(id)sender
{
    if ([self baseViewControllerVisible])
    {
        [self hideMenuAnimated:YES];
    }
    else
    {
        [self showMenuAnimated:YES];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Instance Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)baseViewControllerVisible
{
    return self.rootViewController.view.frame.origin.y >= [UIScreen mainScreen].bounds.size.height;
}

- (BOOL)rootViewControllerViewHasLoaded
{
    return self.rootViewController.view.superview || self.cachedSuperView;
}

- (BOOL)drawerViewIsDetached
{
    UIView *currentSuperView = self.drawerController.view.superview;
    while (currentSuperView.superview)
    {
        if (currentSuperView == self.view)
        {
            break;
        }
        
        currentSuperView = currentSuperView.superview;
    }
    
    if (currentSuperView != self.view)
    {
        return YES;
    }
    
    return NO;
}

- (void)cacheRootViewAndHide
{
    self.cachedSuperView = self.rootViewController.view.superview;
    [self.cachedSuperView addSubview:self.drawerController.view];
    [self.rootViewController.view removeFromSuperview];
}

- (void)moveMenuViewToBack
{
    self.drawerController.view.frame = [self presentedViewFrame];
    [self.rootViewController.view.superview addSubview:self.drawerController.view];
    [self.rootViewController.view.superview sendSubviewToBack:self.drawerController.view];
}

- (void)addDrawerViewAndMoveToBack {
    [self.view addSubview:self.drawerController.view];
    [self.view sendSubviewToBack:self.drawerController.view];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Display Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)showMenuAnimated:(BOOL)animated
{
    if (!self.isAnimating)
    {
        if (![self baseViewControllerVisible])
        {
            if (![self rootViewControllerViewHasLoaded])
            {
                self.pendingPresentationState = VDNavigationControllerPresentationStateOpen;
                return;
            }
            
            self.isAnimating = YES;
            
            if ([self drawerViewIsDetached])
            {
                self.cachedSuperView = nil;
                [self.drawerController.view removeFromSuperview];
                
                [self moveMenuViewToBack];
            }
            
            if (self.vdNavigationControllerDelegate && [self.vdNavigationControllerDelegate respondsToSelector:@selector(vdNavigationControllerWillPresentDrawer:)])
            {
                [self.vdNavigationControllerDelegate vdNavigationControllerWillPresentDrawer:self];
            }
            
            if (animated)
            {
                [UIView animateWithDuration:0.25 animations:^
                 {
                     self.rootViewController.view.frame = [self dismissedViewFrame];
                 }
                 completion:^(BOOL finished)
                 {
                     [self cacheRootViewAndHide];
                     
                     self.isAnimating = NO;
                     self.presentationState = VDNavigationControllerPresentationStateOpen;
                     
                     if (self.vdNavigationControllerDelegate && [self.vdNavigationControllerDelegate respondsToSelector:@selector(vdNavigationControllerDidPresentDrawer:)])
                     {
                         [self.vdNavigationControllerDelegate vdNavigationControllerDidPresentDrawer:self];
                     }
                 }];
            }
            else
            {
                self.rootViewController.view.frame = [self dismissedViewFrame];
                [self cacheRootViewAndHide];
                self.presentationState = VDNavigationControllerPresentationStateOpen;

                self.isAnimating = NO;
                
                if (self.vdNavigationControllerDelegate && [self.vdNavigationControllerDelegate respondsToSelector:@selector(vdNavigationControllerDidPresentDrawer:)])
                {
                    [self.vdNavigationControllerDelegate vdNavigationControllerDidPresentDrawer:self];
                }
            }
        }
    }
}

- (void)hideMenuAnimated:(BOOL)animated
{
    if (!self.isAnimating)
    {
        if ([self baseViewControllerVisible])
        {
            if (![self rootViewControllerViewHasLoaded])
            {
                self.pendingPresentationState = VDNavigationControllerPresentationStateClosed;
                return;
            }
            
            self.isAnimating = YES;
            
            if (self.vdNavigationControllerDelegate && [self.vdNavigationControllerDelegate respondsToSelector:@selector(vdNavigationControllerWillDismissDrawer:)])
            {
                [self.vdNavigationControllerDelegate vdNavigationControllerWillDismissDrawer:self];
            }
            
            [self.cachedSuperView addSubview:self.rootViewController.view];
            
            if (animated)
            {
                [UIView animateWithDuration:0.25f animations:^
                {
                    self.rootViewController.view.frame = [self presentedViewFrame];
                }
                completion:^(BOOL finished)
                {
                    [self addDrawerViewAndMoveToBack];
                    self.isAnimating = NO;
                    self.presentationState = VDNavigationControllerPresentationStateClosed;
                    
                    if (self.vdNavigationControllerDelegate && [self.vdNavigationControllerDelegate respondsToSelector:@selector(vdNavigationControllerDidDismissDrawer:)])
                    {
                        [self.vdNavigationControllerDelegate vdNavigationControllerDidDismissDrawer:self];
                    }
                }];
            }
            else
            {
                self.rootViewController.view.frame = [self presentedViewFrame];
                [self addDrawerViewAndMoveToBack];
                self.presentationState = VDNavigationControllerPresentationStateClosed;
                
                self.isAnimating = NO;
                
                if (self.vdNavigationControllerDelegate && [self.vdNavigationControllerDelegate respondsToSelector:@selector(vdNavigationControllerDidDismissDrawer:)])
                {
                    [self.vdNavigationControllerDelegate vdNavigationControllerDidDismissDrawer:self];
                }
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UINavigationController Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.presentationState == VDNavigationControllerPresentationStateOpen) {
        
        if (self.cachedSuperView) {
            [self.cachedSuperView addSubview:self.rootViewController.view];
        }
        self.rootViewController.view.userInteractionEnabled = NO;
        self.rootViewController.view.hidden = YES;
        [self addDrawerViewAndMoveToBack];
    }
    
    [super pushViewController:viewController animated:animated];
    
        NSLog(@"view stack = %@", [self.view.subviews[0] subviews]);
}

- (UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *poppedViewController = [super popViewControllerAnimated:animated];
    
    if (self.viewControllers.count <= 2 && self.presentationState == VDNavigationControllerPresentationStateOpen)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((UINavigationControllerHideShowBarDuration + 0.4f) * NSEC_PER_SEC) ), dispatch_get_main_queue(), ^
        {
            [self moveMenuViewToBack];
            [self cacheRootViewAndHide];
            self.rootViewController.view.userInteractionEnabled = YES;
            self.rootViewController.view.hidden = NO;
            self.rootViewController.view.frame = [self dismissedViewFrame];
        });
    }
    
    return poppedViewController;
}

- (NSArray*)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray *poppedControllers = [super popToRootViewControllerAnimated:animated];
    
    if (self.presentationState == VDNavigationControllerPresentationStateOpen)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((UINavigationControllerHideShowBarDuration + 0.4f) * NSEC_PER_SEC) ), dispatch_get_main_queue(), ^
        {
            [self moveMenuViewToBack];
            [self cacheRootViewAndHide];
            self.rootViewController.view.userInteractionEnabled = YES;
            self.rootViewController.view.hidden = NO;
            self.rootViewController.view.frame = [self dismissedViewFrame];
        });
    }
    return poppedControllers;
}

@end
