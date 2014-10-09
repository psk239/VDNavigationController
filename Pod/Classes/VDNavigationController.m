//
//  VDNavigationController.m
//  VDNavigationController
//
//  Created by Paul Kim on 9/17/14.
//
//

#import "VDNavigationController.h"
#import "VDDrawerViewController.h"


@interface VDMultiplexer : NSObject

/**
 *  A collection of behavior objects to forward messages to.
 */
@property (nonatomic, strong) NSMutableArray *mutableTargets;

/**
 *  Adds the target. If the target is already included in the list of targets, does nothing.
 *
 *  @param target The new target to add.
 */
- (void)addTarget:(id)target;


/**
 *  Renoves the target. If the target is not included in the list of targets, does nothing.
 *
 *  @param target The target to remove
 */
- (void)removeTarget:(id)target;

@end


@interface VDMultiplexer () //private
@end

@implementation VDMultiplexer

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype) init {
    if (self = [super init]) {
        self.mutableTargets = [NSMutableArray new];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Mutators
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addTarget:(id)target {
    if (![self targetAlreadyExists:target]) {
        [self.mutableTargets addObject:[self convertedTarget:target]];
    }
}

- (void)removeTarget:(id)target {
    NSValue *value = [self convertedTarget:target];
    NSValue *valueToDelete = nil;
    for (NSValue* currentValue in self.mutableTargets) {
        if ([currentValue isEqualToValue:value]) {
            valueToDelete = currentValue;
            break;
        }
    }
    
    if (valueToDelete) {
        [self.mutableTargets removeObject:valueToDelete];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Convenience Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSValue*)convertedTarget:(id)target {
    NSValue *value = [NSValue valueWithNonretainedObject:target];
    return value;
}

- (BOOL)targetAlreadyExists:(id)target {
    NSValue *value = [self convertedTarget:target];
    for (NSValue* currentValue in self.mutableTargets) {
        if ([currentValue isEqualToValue:value]) {
            return YES;
        }
    }
    return NO;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Overwrite Apple Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    
    NSMethodSignature *sig = [super methodSignatureForSelector:sel];
    if (!sig) {
        for (NSValue* obj in self.mutableTargets) {
            if ((sig = [[obj nonretainedObjectValue] methodSignatureForSelector:sel])) {
                break;
            }
        }
    }
    return sig;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    
    BOOL base = [super respondsToSelector:aSelector];
    if (base) {
        return base;
    }
    
    for (NSValue* obj in self.mutableTargets) {
        if ([[obj nonretainedObjectValue] respondsToSelector:aSelector]) {
            return YES;
        }
    }
    
    return NO;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    for (NSValue* obj in self.mutableTargets) {
        if ([[obj nonretainedObjectValue] respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:[obj nonretainedObjectValue]];
        }
    }
}

@end





@interface VDNavigationController () <UINavigationControllerDelegate>
@property (nonatomic, strong) VDMultiplexer<UINavigationControllerDelegate> *delegateMultiplexer;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) NSString *cachedTitle;
@property (nonatomic, strong) NSArray *cachedLeftBarButtonItems;
@property (nonatomic, strong) NSArray *cachedRightBarButtonItems;
@property (nonatomic, strong) UIView *cachedSuperView;

@property (nonatomic) BOOL isAnimating;
@property (nonatomic) VDNavigationControllerPresentationState pendingPresentationState;
@end

@implementation VDNavigationController
@synthesize delegate = _delegate;

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController])
    {
        _rootViewController = rootViewController;
        
        _delegate = self.delegateMultiplexer;
        [self.delegateMultiplexer addTarget:self];
        
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Accessors
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (VDMultiplexer<UINavigationControllerDelegate> *)delegateMultiplexer
{
    if (!_delegateMultiplexer)
    {
        _delegateMultiplexer = (VDMultiplexer<UINavigationControllerDelegate> *)[[VDMultiplexer alloc] init];
    }
    
    return _delegateMultiplexer;
}


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

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    [self.delegateMultiplexer addTarget:delegate];
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
        self.cachedRightBarButtonItems = nil;
        self.cachedLeftBarButtonItems = nil;
        self.cachedTitle = nil;
        
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

- (void)setBarButtonItemsEnabled:(BOOL)enabled {
    self.rootViewController.navigationController.navigationBar.userInteractionEnabled = enabled;
}

- (void)swapBarButtonItemsForViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    NSArray *leftBarButtonItems = viewController.navigationItem.leftBarButtonItems;
    NSArray *rightBarButtonItems = viewController.navigationItem.rightBarButtonItems;

    if ([[viewController class] isSubclassOfClass:[VDDrawerViewController class]])
    {
        leftBarButtonItems = [(VDDrawerViewController*)viewController leftBarButtonItems];
        rightBarButtonItems = [(VDDrawerViewController*)viewController rightBarButtonItems];
        
        self.cachedLeftBarButtonItems = self.rootViewController.navigationItem.leftBarButtonItems;
        self.cachedRightBarButtonItems = self.rootViewController.navigationItem.rightBarButtonItems;
    }
    else if (self.cachedLeftBarButtonItems || self.cachedRightBarButtonItems)
    {
        leftBarButtonItems = self.cachedLeftBarButtonItems;
        rightBarButtonItems = self.cachedRightBarButtonItems;
    }
    
    [self.rootViewController.navigationItem setLeftBarButtonItems:leftBarButtonItems animated:animated];
    [self.rootViewController.navigationItem setRightBarButtonItems:rightBarButtonItems animated:animated];
}

- (void)swapTitleForViewController:(UIViewController*)viewController animated:(BOOL)animated
{
    if (viewController == self.drawerController) {
        self.cachedTitle = self.rootViewController.title;
        self.rootViewController.title = viewController.title;
    } else if (self.cachedTitle) {
        self.rootViewController.title = self.cachedTitle;
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
            [self setBarButtonItemsEnabled:NO];
            
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
                     [self swapBarButtonItemsForViewController:self.drawerController animated:YES];
                     [self swapTitleForViewController:self.drawerController animated:YES];
                     [self cacheRootViewAndHide];

                     [self setBarButtonItemsEnabled:YES];
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
                [self swapBarButtonItemsForViewController:self.drawerController animated:NO];
                [self swapTitleForViewController:self.drawerController animated:NO];
                [self cacheRootViewAndHide];
                
                [self addChildViewController:self.drawerController];
                
                self.presentationState = VDNavigationControllerPresentationStateOpen;
                
                [self setBarButtonItemsEnabled:YES];
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
                    [self swapBarButtonItemsForViewController:self.rootViewController animated:YES];
                    [self swapTitleForViewController:self.rootViewController animated:YES];

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
                [self swapBarButtonItemsForViewController:self.rootViewController animated:NO];
                [self swapTitleForViewController:self.rootViewController animated:NO];
                
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
#pragma mark - Modal Presentation Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    [super presentViewController:viewControllerToPresent animated:flag completion:^
    {
        if (self.cachedTitle)
        {
            self.rootViewController.title = self.cachedTitle;
        }
        
        if (completion) {
            completion();
        }
    }];
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
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((UINavigationControllerHideShowBarDuration + 0.4f) * NSEC_PER_SEC * animated) ), dispatch_get_main_queue(), ^
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

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UINavigationController Delegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.isAnimating = YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.isAnimating = NO;
}

@end
