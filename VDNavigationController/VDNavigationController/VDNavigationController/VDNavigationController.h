//
//  VDNavigationController.h
//  VDNavigationController
//
//  Created by Paul Kim on 9/16/14.
//
//

#import <UIKit/UIKit.h>

@protocol VDNavigationControllerDataSource;
@protocol VDNavigationControllerDelegate;

@interface VDNavigationController : UIViewController
@property (nonatomic, weak) id<VDNavigationControllerDelegate> delegate;
@property (nonatomic, weak) id<VDNavigationControllerDataSource> dataSource;
@property (nonatomic, strong, readonly) UINavigationBar *navigationBar;

- (void)reloadData;

@end

@protocol VDNavigationControllerDataSource <NSObject>

@required
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell*)vdNavigationController:(VDNavigationController*)vdController cellForItemAtIndexPath:(NSIndexPath*)indexPath;
- (UIViewController*)vdNavigationController:(VDNavigationController*)vdController viewControllerAtIndex:(NSIndexPath*)indexPath;

@optional
- (NSArray*)vdNavigationController:(VDNavigationController*)vdController leftBarButtonItemsForControllerAtIndex:(NSIndexPath*)indexPath;
- (NSArray*)vdNavigationController:(VDNavigationController*)vdController rightBarButtonItemsForControllerAtIndex:(NSIndexPath*)indexPath;

@end

@protocol VDNavigationControllerDelegate <NSObject>

- (void)vdNavigationController:(VDNavigationController*)vdController didSelectItemAtIndex:(NSIndexPath*)indexPath;

@end