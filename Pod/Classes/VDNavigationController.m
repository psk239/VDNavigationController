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
@property (nonatomic, strong) NSPointerArray *targets;

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
        self.targets = [NSPointerArray weakObjectsPointerArray];
    }
    
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Mutators
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)addTarget:(id)target {
    if (![self targetAlreadyExists:target]) {
        [self.targets addPointer:(__bridge void*)target];
    }
}

- (void)removeTarget:(id)target {
    
    NSValue *valueToDelete = nil;
    
    int i = 0;
    for (id object in self.targets) {
        if ([object isEqual:target]) {
            valueToDelete = object;
            break;
        }
        i++;
    }
    
    if (valueToDelete) {
        [self.targets removePointerAtIndex:i];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Convenience Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)targetAlreadyExists:(id)target {
    return [self.targets.allObjects containsObject:target];
}

- (void)cleanMutableTargets {
    int idx = 0;
    while (self.targets.count > 0 && idx < self.targets.count)
    {
        if ([self.targets pointerAtIndex:idx] == NULL)
        {
            [self.targets removePointerAtIndex:idx];
            idx = 0;
            continue;
        }
        
        idx++;
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Overwrite Apple Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    
    NSMethodSignature *sig = [super methodSignatureForSelector:sel];
    if (!sig) {
        for (id object in self.targets.allObjects) {
            if ((sig = [object methodSignatureForSelector:sel])) {
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
    
    for (id object in self.targets) {
        if ([object respondsToSelector:aSelector]) {
            return YES;
        }
    }
    
    return NO;
}


- (void)forwardInvocation:(NSInvocation *)anInvocation {
    
    [self cleanMutableTargets];
    for (id object in self.targets.allObjects) {
        if ([object respondsToSelector:anInvocation.selector]) {
            [anInvocation invokeWithTarget:object];
        }
    }
}

@end





@interface VDNavigationController () <UINavigationControllerDelegate>
@property (nonatomic, strong) VDMultiplexer<UINavigationControllerDelegate> *delegateMultiplexer;
@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) NSString *cachedTitle;

@property (nonatomic) BOOL isAnimating;
@property (nonatomic) VDNavigationControllerPresentationState pendingPresentationState;
@end

@implementation VDNavigationController
@synthesize delegate = _delegate;

- (instancetype)initWithRootViewController:(UIViewController *)thisRootController
{
    if (self = [super initWithRootViewController:thisRootController])
    {
        self.rootViewController = thisRootController;
        
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

- (void)dealloc
{

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
    return self.view.bounds;
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
    CGRect frame = self.drawerController.view.frame;

    if (self.drawerController.edgesForExtendedLayout == UIRectEdgeNone) {
        
        if (!self.navigationBarHidden) {
            CGFloat navigationBarHeight = self.navigationBar.frame.size.height;
            frame.origin.y += navigationBarHeight;
            frame.size.height -= navigationBarHeight;
        }
        
        if (![UIApplication sharedApplication].statusBarHidden) {
            CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            frame.origin.y += statusBarHeight;
            frame.size.height -= statusBarHeight;
        }
    }
    
    frame.origin.y += self.drawerYOffset;
    frame.size.height -= self.drawerYOffset;
    
    self.drawerController.view.frame = frame;

    
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

        self.rootViewController = viewController;
        
        self.rootViewController.view.frame = [self dismissedViewFrame];
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
    return [self.viewControllers count] == 1 && self.viewControllers[0] == self.drawerController;
}

- (BOOL)rootViewControllerViewHasLoaded
{
    return self.rootViewController.view.superview || self.viewControllers[0] == self.drawerController;
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

- (void)moveMenuViewToBack
{
    self.viewControllers = @[self.rootViewController];
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
                     [self swapTitleForViewController:self.drawerController animated:YES];
                     self.viewControllers = @[self.drawerController];
                     
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
                [self swapTitleForViewController:self.drawerController animated:NO];
                self.viewControllers = @[self.drawerController];
                
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
            
            [self.drawerController.view addSubview:self.rootViewController.view];
            
            if (animated)
            {
                [UIView animateWithDuration:0.25f animations:^
                {
                    self.rootViewController.view.frame = [self presentedViewFrame];
                }
                completion:^(BOOL finished)
                {
                    [self swapTitleForViewController:self.rootViewController animated:YES];
                    [self.rootViewController.view removeFromSuperview];
                    self.viewControllers = @[self.rootViewController];
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
#pragma mark - UINavigationController Delegate Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.isAnimating = YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.isAnimating = NO;
    
    if (viewController == self.rootViewController && self.viewControllers.count == 0 && self.presentationState == VDNavigationControllerPresentationStateClosed)
    {
        [self.rootViewController.view.superview addSubview:self.drawerController.view];
        [self.rootViewController.view.superview sendSubviewToBack:self.drawerController.view];
    }
}

@end
