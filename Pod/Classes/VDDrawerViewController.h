//
//  VDDrawerViewController.h
//  VDNavigationController
//
//  Created by Paul Kim on 9/18/14.
//
//

#import <UIKit/UIKit.h>

@class VDNavigationController;

/**
 *  This class is the class presented by VDNavigationController as the navigation menu. All Menus presented by VDNavigationController 
 *  must be subclasses of VDDrawerViewController
 */
@interface VDDrawerViewController : UIViewController

/**
 *  The VDNavigationController that is presenting this instance of VDDrawerViewController
 */
@property (nonatomic, weak) VDNavigationController *vdNavController;

/**
 *  The leftBarButtonItems that the VDDrawerViewController presents when the menu is presented
 *  @warning This is a required method. Subclasses must implement this method. Do not call super. Nil is a valid return value
 *
 *  @return An array of UIBarButtonItems or nil
 */
- (NSArray*)leftBarButtonItems;

/**
 *  The rightBarButtonItems that the VDDrawerViewController presents when the menu is presented
 *  @warning This is a required method. Subclasses must implement this method. Do not call super. Nil is a valid return value
 *
 *  @return An array of UIBarButtonItems or nil
 */
- (NSArray*)rightBarButtonItems;

@end
