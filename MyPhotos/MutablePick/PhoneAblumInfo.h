//
//  PhoneAblumInfo.h
//  YiQiXiu
//
//  Created by Sherry on 2019/4/29.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PHFetchResult;

NS_ASSUME_NONNULL_BEGIN

@interface PhoneAblumInfo : NSObject

@property (assign, nonatomic)NSInteger ablumCount;  //相册内图片数量
@property (strong, nonatomic)NSString *ablumName;   //相册名称
@property (strong, nonatomic)PHFetchResult *ablum;  //相册内图片集合relust，若是多图选取，转换成info后就释放
@property (strong, nonatomic)UIImage *ablumCoverImg; //相册封面图

//多图选取需要用到
@property (strong, nonatomic)NSArray *photoInfoArray;  //相册内图片集合info


@end

NS_ASSUME_NONNULL_END
