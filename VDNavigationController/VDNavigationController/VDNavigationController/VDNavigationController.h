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

@interface VDNavigationController : UINavigationController
@property (nonatomic, weak) id<VDNavigationControllerDelegate> vdNavigationControllerDelegate;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) VDDrawerViewController *drawerController;

- (void)switchToViewController:(UIViewController*)viewController animated:(BOOL)animated;

- (IBAction)menuButtonPressed:(id)sender;

- (void)showMenuAnimated:(BOOL)animated;
- (void)hideMenuAnimated:(BOOL)animated;

@end

@protocol VDNavigationControllerDelegate <NSObject>

@optional
- (void)vdNavigationControllerWillPresentDrawer:(VDNavigationController*)navController;
- (void)vdNavigationControllerDidPresentDrawer:(VDNavigationController*)navController;

- (void)vdNavigationControllerWillDismissDrawer:(VDNavigationController*)navController;
- (void)vdNavigationControllerDidDismissDrawer:(VDNavigationController*)navController;

@end