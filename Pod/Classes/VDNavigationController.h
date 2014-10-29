//
//  VDNavigationController.h
//  VDNavigationController
//
//  Created by Paul Kim on 9/17/14.
//
//

#import <UIKit/UIKit.h>

@class VDDrawerViewController;

@protocol  VDNavigationControllerDelegate;


/**
 *  This enumeration describes the various states
 */
typedef NS_ENUM(NSUInteger, VDNavigationControllerPresentationState) {
    /**
     *  The menu state is unknown
     */
    VDNavigationControllerPresentationStateNone,
    /**
     *  The menu is visible
     */
    VDNavigationControllerPresentationStateOpen,
    /**
     *  The menu is hidden
     */
    VDNavigationControllerPresentationStateClosed
};


/**
 *  The standard animation block
 */
typedef void (^VDNavigationControllerAnimationBlock)(void);

/**
 *  This class is where all the VDNavigationDrawer magic happens. This class is responsible for managing the display of the VDDrawerViewController. 
 *  The RootViewController property of this view is the UIViewController that is displayed in front of the Drawer Menu. The Drawer menu is left undefined,
 *  it is up to you to implement your own custom style of navigation. The only requirement of this class is that you must provide a RootViewController and
 *  a valid subclass of VDDrawerViewController for the drawerController.
 *
 *  @see VDDrawerViewController.
 */
@interface VDNavigationController : UINavigationController

/**
 *  The delegate for when the menu is displayed or hidden.
 */
@property (nonatomic, weak) id<VDNavigationControllerDelegate> vdNavigationControllerDelegate;

/**
 *  The drawer controller displayed behind the RootViewController.
 */
@property (nonatomic, strong) VDDrawerViewController *drawerController;

/**
 *  The custom animations to include when the menu is shown. Implement this block when you want to include your own animations.
 *  @warning Like with all blocks, make sure you use a weak reference to the VDNavigationController when implementing this block
 */
@property (nonatomic, copy) VDNavigationControllerAnimationBlock showMenuAnimationBlock;

/**
 *  The custom animation to include when the menu is hidden. Implement this block when you want to include your own animations.
 *  @warning Like with all blocks, make sure you use a weak reference to the VDNavigationController when implementing this block
 */
@property (nonatomic, copy) VDNavigationControllerAnimationBlock hideMenuAnimationBlock;

/**
 *  The current presentation state
 */
@property (nonatomic) VDNavigationControllerPresentationState presentationState;

/**
 *  When the Drawer is initially added to the UINavigationController's view, it sometimes is misaligned vertically. If you notice the drawer
 *  vertically jumps when it is initially presented, adjust this property as needed to get the desired layout.
 */
@property (nonatomic) CGFloat drawerYOffset;

/**
 *  This is the method only method that should be used in order to display a new UIViewController as the RootViewController. 
 *  For example, if UIViewController A is currently being displayed, and you want UIViewController B to be displayed instead,
 *  calls this method while passing UIViewController B as an argument.
 *
 *  @param viewController The view controller to display
 *  @param animated       Whether or not to animate the transition
 */
- (void)switchToViewController:(UIViewController*)viewController animated:(BOOL)animated;

/**
 *  This method either displays or hides the menu depending on the current presentationState
 *
 *  @param sender The sender
 */
- (IBAction)menuButtonPressed:(id)sender;

/**
 *  This method opens the menu, showing the drawerController and optionally animating the RootViewController away.
 *
 *  @param animated Whether or not to animate the RootViewController as it is dismissed downwards.
 */
- (void)showMenuAnimated:(BOOL)animated;

/**
 *  This method hides the menu, showing the RootViewController by optionally animating it upwards, over the drawerController
 *
 *  @param animated Whether or not to animate the RootViewController as it is presented upwards.
 */
- (void)hideMenuAnimated:(BOOL)animated;

/**
 *  The setter for the showMenuAnimationBlock. This needs to be declared so autocomplete works correctly.
 *  @warning Like with all blocks, make sure you use a weak reference to the VDNavigationController when implementing this block
 *
 *  @param showMenuAnimationBlock The animation block to be invoked when the menu is shown.
 */
- (void)setShowMenuAnimationBlock:(VDNavigationControllerAnimationBlock)showMenuAnimationBlock;

/**
 *  The setter for the hideMenuAnimationBlock. This needs to be declared so autocomplete works correctly.
 *  @warning Like with all blocks, make sure you use a weak reference to the VDNavigationController when implementing this block
 *
 *  @param hideMenuAnimationBlock The animation block to be invoked when the menu is hidden.
 */
- (void)setHideMenuAnimationBlock:(VDNavigationControllerAnimationBlock)hideMenuAnimationBlock;

@end

/**
 *  This Protocol is responsible for letting a delegate know when VDNavigationController has presented or dismissed the menu
 */
@protocol VDNavigationControllerDelegate <NSObject>

@optional

/**
 *  The VDNavigationController is about to present the menu
 *
 *  @param navController The instance of VDNavigationController presenting the menu
 */
- (void)vdNavigationControllerWillPresentDrawer:(VDNavigationController*)navController;

/**
 *  The VDNavigationController finished presenting the menu
 *
 *  @param navController The instance of VDNavigationController presenting the menu
 */
- (void)vdNavigationControllerDidPresentDrawer:(VDNavigationController*)navController;

/**
 *  The VDNavigationController is about to hide the menu
 *
 *  @param navController The instance of VDNavigationController dismissing the menu
 */
- (void)vdNavigationControllerWillDismissDrawer:(VDNavigationController*)navController;

/**
 *  The VDNavigationController did finish hiding the menu
 *
 *  @param navController The instance of VDNavigationController dismissing the menu
 */
- (void)vdNavigationControllerDidDismissDrawer:(VDNavigationController*)navController;

@end