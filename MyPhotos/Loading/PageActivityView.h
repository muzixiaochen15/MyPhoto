//
//  PageActivityView.h
//  YiQiXiu
//
//  Created by Sherry on 16/7/22.
//  Copyright © 2016年 Sherry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageActivityViewInfo.h"

@protocol  PageActivityViewDelegate<NSObject>

- (void)startToReloadData;

@end

@interface PageActivityView : UIView

@property (nonatomic, strong)UIButton *titleButton;
@property (nonatomic, strong)UIImageView *activityImageView;
@property (nonatomic, strong)PageActivityViewInfo *info;
@property (nonatomic, weak)id<PageActivityViewDelegate>delegate;

- (void)resetSuperViewAndTitle:(UIView *)superView loadText:(NSString *)loadText;
- (void)finishLoading:(BOOL)isSuccess;

/** 加载动画：竖排 */
- (void)resetSuperViewAndTitle:(UIView *)superView loadText:(NSString *)loadText withIsLoading:(BOOL)isLoading;
/** 加载动画：横排 */
- (void)resetVerSuperViewAndTitle:(UIView *)superView loadText:(NSString *)loadText withIsLoading:(BOOL)isLoading;
/** 添加动画 */
- (void)animationNowSet:(BOOL)isAdd;
@end
