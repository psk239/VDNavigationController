//
//  VDCollectionViewCell.m
//  VDNavigationController
//
//  Created by Paul Kim on 9/16/14.
//
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Initializers
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Accessors
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (UIImageView*)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.image = [UIImage imageNamed:@"icon"];
    }
    
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - LifeCycle Methods
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.imageView.superview) {
        [self.contentView addSubview:self.imageView];
    }
    
    if (!self.titleLabel.superview) {
        [self.contentView addSubview:self.titleLabel];
    }
    
    [self.titleLabel sizeToFit];
}

- (void)updateConstraints {
    NSDictionary *bindings = NSDictionaryOfVariableBindings(_imageView, _titleLabel);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-_imageView-_titleLabel-|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|_imageView|" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|_titleLabel|" options:0 metrics:nil views:bindings]];

    [super updateConstraints];
}

@end
