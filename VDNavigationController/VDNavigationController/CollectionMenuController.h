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

@interface CollectionMenuController : UIViewController
//@property (nonatomic, weak) id<VDNavigationControllerDelegate> delegate;
@property (nonatomic, weak) id<VDNavigationControllerDataSource> dataSource;
@property (nonatomic, strong) NSArray *sectionNames;

- (void)reloadData;
- (UIButton*)sectionButtonTemplate;
- (void)setSegmentedButtonColor:(UIColor*)color forControlState:(UIControlState)state;
- (void)registerWithCollectionViewCellClass:(Class)collectionViewCellClass forReuseIdentifier:(NSString*)reuseIdentifier;
- (UICollectionViewCell*)dequeueReusableCellForIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath;

@end

@protocol VDNavigationControllerDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInSection:(NSInteger)section;
- (UICollectionViewCell*)vdNavigationController:(CollectionMenuController*)vdController cellForItemAtIndexPath:(NSIndexPath*)indexPath;
- (UIViewController*)vdNavigationController:(CollectionMenuController*)vdController viewControllerAtIndex:(NSIndexPath*)indexPath;

@optional
- (NSArray*)vdNavigationController:(CollectionMenuController*)vdController leftBarButtonItemsForControllerAtIndex:(NSIndexPath*)indexPath;
- (NSArray*)vdNavigationController:(CollectionMenuController*)vdController rightBarButtonItemsForControllerAtIndex:(NSIndexPath*)indexPath;

@end

//@protocol VDNavigationControllerDelegate <NSObject>
//
//- (void)vdNavigationController:(VDNavigationController*)vdController didSelectItemAtIndex:(NSIndexPath*)indexPath;
//
//@end