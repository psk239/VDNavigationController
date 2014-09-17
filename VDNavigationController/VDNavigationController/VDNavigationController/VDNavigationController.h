//
//  VDNavigationController.h
//  VDNavigationController
//
//  Created by Paul Kim on 9/17/14.
//
//

#import <UIKit/UIKit.h>

@protocol  VDNavigationControllerDelegate;

@interface VDNavigationController : UINavigationController
@property (nonatomic, weak) id<VDNavigationControllerDelegate> vdNavigationControllerDelegate;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) UIViewController *baseViewController;

- (void)showMenuAnimated:(BOOL)animated;
- (void)hideMenuAnimated:(BOOL)animated;

@end

@protocol VDNavigationControllerDelegate <NSObject>

- (UIViewController*)vdNavigationController:(VDNavigationController*)controller controllerAtIndex:(NSIndexPath*)index;

@end