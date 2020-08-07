//
//  LocalAlbumCell.m
//  YiQiXiu
//
//  Created by qunlee on 2017/6/14.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import "LocalAlbumCell.h"
#import "PureLayout.h"
#import "ConstantUI.h"

@implementation LocalAlbumCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _albumImageView = [UIImageView newAutoLayoutView];
        [self addSubview:_albumImageView];
        _albumImageView.contentMode = UIViewContentModeScaleAspectFill;
        _albumImageView.clipsToBounds = YES;
        [_albumImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 0.0f) excludingEdge:ALEdgeRight];
        [_albumImageView autoSetDimension:ALDimensionWidth toSize:70.0f];
        
        _albumTitleLabel = [UILabel newAutoLayoutView];
        _albumTitleLabel.backgroundColor = [UIColor clearColor];
        _albumTitleLabel.textColor = [CommUtls changeToColorWithHexAndRgbString:kBlackColorStr4];
        _albumTitleLabel.textAlignment = NSTextAlignmentLeft;
        _albumTitleLabel.font = [UIFont systemFontOfSize:kTitleSize];
        [self addSubview:_albumTitleLabel];
        [_albumTitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_albumImageView withOffset:15.0f];
        [_albumTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25.0f];
        [_albumTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:100.0f];
        [_albumTitleLabel autoSetDimension:ALDimensionHeight toSize:16.0f];
        
        _albumPhotoNumLabel = [UILabel newAutoLayoutView];
        _albumPhotoNumLabel.backgroundColor = [UIColor clearColor];
        _albumPhotoNumLabel.textColor = [CommUtls changeToColorWithHexAndRgbString:@"#333333"];
        _albumPhotoNumLabel.textAlignment = NSTextAlignmentLeft;
        _albumPhotoNumLabel.font = [UIFont systemFontOfSize:kFont_Size_13];
        [self addSubview:_albumPhotoNumLabel];
        [_albumPhotoNumLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_albumImageView withOffset:15.0f];
        [_albumPhotoNumLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_albumTitleLabel withOffset:10.0f];
        [_albumPhotoNumLabel autoSetDimension:ALDimensionHeight toSize:14.0f];
        [_albumPhotoNumLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:100.0f];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
