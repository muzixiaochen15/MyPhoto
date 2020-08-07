//
//  SelectImageCollectionViewCell.m
//  YiQiXiu
//
//  Created by Sherry on 2019/9/24.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import "SelectImageCollectionViewCell.h"

@implementation SelectImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        CGFloat viewWidth = self.frame.size.height ;
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 11,viewWidth - 11, viewWidth - 11)];
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        _imgView.clipsToBounds = YES;
        [self addSubview:_imgView];
        _imgView.backgroundColor = [UIColor whiteColor];
        _imgView.layer.cornerRadius = 4.0f;
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(CGRectGetWidth(frame) - 22, 0, 22, 22);
        _deleteBtn.layer.cornerRadius = 11;
        [_deleteBtn setImage:[UIImage imageNamed:@"localPhoto_delete"] forState:UIControlStateNormal];
        [self addSubview:_deleteBtn];
    }
    return self;
}

@end
