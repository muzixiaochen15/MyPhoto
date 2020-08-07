//
//  PageActivityViewInfo.h
//  YiQiXiu
//
//  Created by Sherry on 2017/11/8.
//  Copyright © 2017年 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PageActivityViewInfo : NSObject

//加载页的背景色，默认为透明
@property (strong, nonatomic) UIColor *backColor;

//加载页的文字颜色，“加载中”,默认为666666
@property (strong, nonatomic) UIColor *titleColor;


@end
