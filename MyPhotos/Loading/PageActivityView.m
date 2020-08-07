//
//  PageActivityView.m
//  YiQiXiu
//
//  Created by Sherry on 16/7/22.
//  Copyright © 2016年 Sherry. All rights reserved.
//

#import "PageActivityView.h"
#import "ConstantUI.h"

@implementation PageActivityView
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];//[CommUtls changeToColorWithHexAndRgbString:kWhiteColorStrF4];
    }
    return self;
}

- (void)resetSuperViewAndTitle:(UIView *)superView loadText:(NSString *)loadText
{
    if (_activityImageView == nil) {
        self.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
        UIImage *image = [UIImage imageNamed:@"activityImage"];
        NSInteger imageHeight = image.size.height;
        NSInteger originY = (self.frame.size.height - imageHeight) / 2 - 30;
        UIImageView *activityImage = [[UIImageView alloc] initWithImage:image];
        activityImage.frame = CGRectMake((self.frame.size.width - image.size.width) / 2,
                                         originY,
                                         image.size.width,
                                         image.size.height);
        [self addSubview:activityImage];
        _activityImageView = activityImage;
        
        UIImage *logoImage = [UIImage imageNamed:@"activityLogoImage"];
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
        logoImageView.frame = activityImage.frame;
        logoImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:logoImageView];
        
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, logoImageView.frame.origin.y + logoImageView.frame.size.height, self.frame.size.width, 50)];
        [self addSubview:titleButton];
        
        if (_info.titleColor) {
            [titleButton setTitleColor:_info.titleColor forState:UIControlStateNormal];
        } else {
            [titleButton setTitleColor:[CommUtls changeToColorWithHexAndRgbString:kNewBottomIconColorStr] forState:UIControlStateNormal];
        }
        titleButton.titleLabel.font = [UIFont systemFontOfSize:kTitleSize];
        [titleButton addTarget:self action:@selector(reloadButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        _titleButton = titleButton;
        
        [superView addSubview:self];
    }
    
    if (_info.backColor) {
        self.backgroundColor = _info.backColor;
    }
    if (loadText.length > 0) {
        [_titleButton setTitle:loadText forState:UIControlStateNormal];
    }else{
        [_titleButton setTitle:@"加载中..." forState:UIControlStateNormal];
    }
    [self animationNowSet:YES];
}

#pragma mark - 竖排
- (void)resetSuperViewAndTitle:(UIView *)superView loadText:(NSString *)loadText withIsLoading:(BOOL)isLoading{
    if (_activityImageView == nil) {
        self.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
        UIImage *image = [UIImage imageNamed:@"activityImage"];
        NSInteger imageHeight = image.size.height;
        NSInteger originY = (self.frame.size.height - imageHeight) / 2 - 30;
        UIImageView *activityImage = [[UIImageView alloc] initWithImage:image];
        activityImage.frame = CGRectMake((self.frame.size.width - image.size.width) / 2,
                                         originY,
                                         image.size.width,
                                         image.size.height);
        [self addSubview:activityImage];
        _activityImageView = activityImage;
        
        UIImage *logoImage = [UIImage imageNamed:@"activityLogoImage"];
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
        logoImageView.frame = activityImage.frame;
        logoImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:logoImageView];
        
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, logoImageView.frame.origin.y + logoImageView.frame.size.height, self.frame.size.width, 50)];
        [self addSubview:titleButton];
        
        if (_info.titleColor) {
            [titleButton setTitleColor:_info.titleColor forState:UIControlStateNormal];
        } else {
            [titleButton setTitleColor:[CommUtls changeToColorWithHexAndRgbString:kNewBottomIconColorStr] forState:UIControlStateNormal];
        }
        titleButton.titleLabel.font = [UIFont systemFontOfSize:kContentSize];
        [titleButton addTarget:self action:@selector(reloadButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        _titleButton = titleButton;
        
        [superView addSubview:self];
    }
    
    if (_info.backColor) {
        self.backgroundColor = _info.backColor;
    }
    if (loadText.length > 0) {
        [_titleButton setTitle:loadText forState:UIControlStateNormal];
    }else{
        [_titleButton setTitle:@"加载中..." forState:UIControlStateNormal];
    }
    
    if (isLoading) {
        [self animationNowSet:YES];
    }
}

#pragma mark - 横排
- (void)resetVerSuperViewAndTitle:(UIView *)superView loadText:(NSString *)loadText withIsLoading:(BOOL)isLoading{
    if (_activityImageView == nil) {
        self.frame = CGRectMake(0, 0, superView.frame.size.width, superView.frame.size.height);
        UIImage *image = [UIImage imageNamed:@"activityImage"];
        NSInteger originY = (self.frame.size.height - 24)  - 16;
        UIImageView *activityImage = [[UIImageView alloc] initWithImage:image];
        activityImage.frame = CGRectMake(self.frame.size.width/2 - 41.5,
                                         originY,
                                         24,
                                         24);
        [self addSubview:activityImage];
        _activityImageView = activityImage;
        
        UIImage *logoImage = [UIImage imageNamed:@"activityLogoImage"];
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:logoImage];
        logoImageView.frame = activityImage.frame;
        logoImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:logoImageView];
        
        UIButton *titleButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(activityImage.frame) + 8, originY + 2, 100, 20)];
        [self addSubview:titleButton];
        
        if (_info.titleColor) {
            [titleButton setTitleColor:_info.titleColor forState:UIControlStateNormal];
        } else {
            [titleButton setTitleColor:[CommUtls changeToColorWithHexAndRgbString:kNewBottomIconColorStr] forState:UIControlStateNormal];
        }
        titleButton.titleLabel.font = [UIFont systemFontOfSize:kContentSize];
        [titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [titleButton addTarget:self action:@selector(reloadButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        _titleButton = titleButton;
        
        [superView addSubview:self];
    }
    
    if (_info.backColor) {
        self.backgroundColor = _info.backColor;
    }
    if (loadText.length > 0) {
        [_titleButton setTitle:loadText forState:UIControlStateNormal];
    }else{
        [_titleButton setTitle:@"加载中..." forState:UIControlStateNormal];
    }
    
    if (isLoading) {
        [self animationNowSet:YES];
    }
}

- (void)finishLoading:(BOOL)isSuccess
{
    if (isSuccess) {
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else
    {
        [self animationNowSet:NO];
        [_titleButton setTitle:@"加载失败，点击重新加载" forState:UIControlStateNormal];
    }
}

- (void)animationNowSet:(BOOL)isAdd
{
    if (isAdd) {
        CABasicAnimation* rotationAnimation;
        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        rotationAnimation.duration = 1;
        rotationAnimation.repeatCount = HUGE_VALF;
        rotationAnimation.cumulative = YES;
        [_activityImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    }
    else{
        [_activityImageView.layer removeAnimationForKey:@"rotationAnimation"];
    }
}

- (void)reloadButtonOnClick
{
    if ([self.delegate respondsToSelector:@selector(startToReloadData)]) {
        [self.delegate startToReloadData];
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
