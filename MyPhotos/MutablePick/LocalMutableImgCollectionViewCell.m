//
//  LocalMutableImgCollectionViewCell.m
//  YiQiXiu
//
//  Created by Sherry on 2019/8/22.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import "LocalMutableImgCollectionViewCell.h"

@implementation LocalMutableImgCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat viewWidth = self.frame.size.width;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,viewWidth,viewWidth)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        //Photo_Pre_select
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat preImgBtnWidth = _imageView.frame.size.width / 2;
        _selectBtn.frame = CGRectMake(preImgBtnWidth, 0, preImgBtnWidth, preImgBtnWidth);
        [self addSubview:_selectBtn];
        UIImage *preViewImg = [UIImage imageNamed:@"Photo_pre_unselect"];
        [_selectBtn setImage:preViewImg forState:UIControlStateNormal];
        [_selectBtn setImageEdgeInsets:UIEdgeInsetsMake(5, preImgBtnWidth - preViewImg.size.width - 5, preImgBtnWidth - preViewImg.size.height - 5, 5)];
    }
    return self;
}


@end
