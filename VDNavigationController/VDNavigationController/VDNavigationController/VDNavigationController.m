//
//  VDNavigationController.m
//  VDNavigationController
//
//  Created by Paul Kim on 9/16/14.
//
//

#import "VDNavigationController.h"
#import "CollectionViewCell.h"

static CGFloat const VDSegmentedButtonHeight = 44.0f;

@interface VDNavigationController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong, readwrite) UINavigationBar *navigationBar;
@property (nonatomic, strong) NSArray *segmentedButtons;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *buttonColorsDict;
@property (nonatomic) NSInteger selectedIndex;
@end

@implementation VDNavigationController

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initializers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype)init {
    if (self = [super init]) {
        [self initializeVars];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initializeVars];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initializeVars];
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View Lifecycle
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)initializeVars {
    self.selectedIndex = -1;
}

- (void)loadView {
    [super loadView];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.collectionView];
    
    if ([self displaySegmentedControl]) {
        self.selectedIndex = 0;
        for (UIButton* button in self.segmentedButtons) {
            [self.view addSubview:button];
        }
        
        //This updates the button states
        [self sectionButtonPressed:self.segmentedButtons[self.selectedIndex]];
    }
    
    [self updateViewConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    UIView *viewAboveCollectionView = self.navigationBar;
    CGFloat collectionViewHeightOffset = self.navigationBar.bounds.size.height;
    
    // Configure Navigation Bar
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:0.0f constant:self.navigationBar.bounds.size.height]];

    // Configure Segmented Controller if necessary
    if ([self displaySegmentedControl]) {
        
        viewAboveCollectionView = self.segmentedButtons[0];
        collectionViewHeightOffset += viewAboveCollectionView.bounds.size.height;
        
        __weak typeof(self) weakSelf = self;
        __weak typeof(NSArray*) weakButtons = self.segmentedButtons;
        [self.segmentedButtons enumerateObjectsUsingBlock:^(UIButton *currentButton, NSUInteger idx, BOOL *stop) {
            
            [weakSelf.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:weakSelf.navigationBar attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
            [weakSelf.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:weakSelf.view attribute:NSLayoutAttributeWidth multiplier:1.0f/[weakButtons count] constant:0.0f]];
            [weakSelf.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:weakSelf.view attribute:NSLayoutAttributeHeight multiplier:0.0f constant:VDSegmentedButtonHeight]];

            if (idx == 0) {
                [weakSelf.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:weakSelf.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
            } else {
                UIButton *previousButton = weakButtons[idx-1];
                [weakSelf.view addConstraint:[NSLayoutConstraint constraintWithItem:currentButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:previousButton attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
            }
        }];
    }
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:viewAboveCollectionView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0.0f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1.0f constant:-collectionViewHeightOffset]];
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    if ([[object class] isSubclassOfClass:[UIButton class]]) {
//        UIButton *button = (UIButton*)object;
//        if ([keyPath isEqualToString:@"highlighted"]) {
//            button.backgroundColor = self.buttonColorsDict[@(UIControlStateHighlighted)];
//        } else if ([keyPath isEqualToString:@"selected"]) {
//            button.backgroundColor = self.buttonColorsDict[@(UIControlStateSelected)];
//        }
//    }
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Accessors
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UINavigationBar*)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 64.0f)];
        _navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return _navigationBar;
}

- (NSArray*)segmentedButtons {
    if (!_segmentedButtons) {
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:[self.sectionNames count]];
        
        [self.sectionNames enumerateObjectsUsingBlock:^(NSString *sectionTitle, NSUInteger idx, BOOL *stop) {
            UIButton *button = [self sectionButtonTemplate];
            button.tag = idx;
            [button setTitle:sectionTitle forState:UIControlStateNormal];
            [mutableArray addObject:button];
        }];
    
        _segmentedButtons = [NSArray arrayWithArray:mutableArray];
    }
    
    return _segmentedButtons;
}

- (UIButton*)sectionButtonTemplate {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width/2.0f, VDSegmentedButtonHeight)];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    button.backgroundColor = self.buttonColorsDict[@(UIControlStateNormal)];
//    [button addObserver:self forKeyPath:@"highlighted" options:0 context:NULL];
//    [button addObserver:self forKeyPath:@"selected" options:0 context:NULL];
    [button addTarget:self action:@selector(sectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (UICollectionView*)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(320.0f/3, 320.0f/3);

        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    
    return _collectionView;
}

- (NSMutableDictionary*)buttonColorsDict {
    if (!_buttonColorsDict) {
        _buttonColorsDict = [NSMutableDictionary dictionaryWithDictionary: @{@(UIControlStateDisabled) : [UIColor grayColor],
                                                                             @(UIControlStateHighlighted) : [UIColor blackColor],
                                                                             @(UIControlStateNormal) : [UIColor whiteColor],
                                                                             @(UIControlStateReserved) : [UIColor whiteColor],
                                                                             @(UIControlStateSelected) : [UIColor redColor],
                                                                             @(UIControlStateApplication) : [UIColor whiteColor]}];
    }
    
    return _buttonColorsDict;
}

- (UICollectionViewCell*)dequeueReusableCellForIdentifier:(NSString*)identifier forIndexPath:(NSIndexPath*)indexPath {
    return [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

- (BOOL)displaySegmentedControl {
    return [self.sectionNames count] > 1;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Setters
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setSegmentedButtonColor:(UIColor*)color forControlState:(UIControlState)state {
    self.buttonColorsDict[@(state)] = color;
    [self sectionButtonPressed:self.segmentedButtons[self.selectedIndex]];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Actions
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)displayViewController:(UIViewController*)viewController {
    [self addChildViewController:viewController];
}

- (void)sectionButtonPressed:(id)sender {
    if ([[sender class] isSubclassOfClass:[UIButton class]]) {
        UIButton *selectedButton = (UIButton*)sender;
        self.selectedIndex = selectedButton.tag;
        
        __weak typeof(self) weakSelf = self;
        [self.segmentedButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
            if (weakSelf.selectedIndex == idx) {
                [button setSelected:YES];
                button.backgroundColor = self.buttonColorsDict[@(UIControlStateSelected)];
            } else {
                [button setSelected:NO];
                button.backgroundColor = self.buttonColorsDict[@(UIControlStateNormal)];
            }
        }];
    }
}

- (void)registerWithCollectionViewCellClass:(Class)collectionViewCellClass forReuseIdentifier:(NSString*)reuseIdentifier {
    [self.collectionView registerClass:collectionViewCellClass forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)reloadData {
    [self.collectionView reloadData];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UICollectionView Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.dataSource) {
        if ([self displaySegmentedControl]) {
            [self.dataSource numberOfItemsInSection:self.selectedIndex];
        }
        return [self.dataSource numberOfItemsInSection:0];
    }
    
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource) {
        return [self.dataSource vdNavigationController:self cellForItemAtIndexPath:indexPath];
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self displayViewController:[self.dataSource vdNavigationController:self viewControllerAtIndex:indexPath]];
}


@end
