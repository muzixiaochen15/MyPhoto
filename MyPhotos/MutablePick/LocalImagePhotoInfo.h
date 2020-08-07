//
//  LocalImagePhotoInfo.h
//  YiQiXiu
//
//  Created by Sherry on 2019/4/30.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PHAsset;

typedef enum : NSUInteger {
    kLocalImgSelectStateNone     = -1,   //未判断过是否已选取
    kLocalImgSelectStateNo       = 0,    //未选取
    kLocalImgSelectStateYes      = 1,
} LocalImgMutableSelectState;  //用户区分图片是否已选取

NS_ASSUME_NONNULL_BEGIN

@interface LocalImagePhotoInfo : NSObject

@property (strong, nonatomic) PHAsset *asset; //用于获取大图
@property (strong, nonatomic) NSString *localIndenter; //本地图片路径，区分图片的唯一性
@property (assign, nonatomic) LocalImgMutableSelectState hasSelect; //是否选中
@property (strong, nonatomic) UIImage *thumImg;  //列表内显示的图片

@end

NS_ASSUME_NONNULL_END
