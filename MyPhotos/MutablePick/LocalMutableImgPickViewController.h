//
//  LocalMutableImgPickViewController.h
//  YiQiXiu
//
//  Created by Sherry on 2019/8/21.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^MutablePickImgFinishBlock)(NSArray *images);

/// 返回上传后url
typedef void(^ImagesUploadFinishBlock)(NSArray *urlImages);

@interface LocalMutableImgPickViewController : UIViewController

//是否需要排序，为NO时会按照用户的选取顺序给出
@property (assign, nonatomic)BOOL needSortImg;

//最多可选取的图片的数量
@property (assign, nonatomic)NSInteger maxCount;

/*
最少可选取的图片的数量，默认为1。
若minCount == maxCount，则表示选取固定的图片数量为maxCount
 */
@property (assign, nonatomic)NSInteger minCount;

//是否需要预览图片
@property (assign, nonatomic)BOOL needBrowsePhoto;

/*
 是否需要原图   重要备注：涉及到内存，请慎用
 若设置该参数为YES，则photoSize不起作用
 */
@property (assign, nonatomic)BOOL needOrginPhoto;

//获取的图片的像素大小，若不设置，则按照828, 1374(plus尺寸)给出
@property (assign, nonatomic)CGSize photoSize;
//当前的loading是否隐藏
@property (nonatomic, assign)BOOL hiddenNotLoading;
@property (copy, nonatomic)MutablePickImgFinishBlock finishBlock;

// 是否需要上传
@property (assign, nonatomic)BOOL isNeedUpload;
// 返回上传后url列表
@property (copy, nonatomic)ImagesUploadFinishBlock uploadBlock;
// 来自拼图
@property (nonatomic, assign) BOOL isFromStitchPic;
//不压缩-图文会用
@property (nonatomic, assign)BOOL isNeedNotCompress;

@property (assign, nonatomic)BOOL needSupportGif;

@end

NS_ASSUME_NONNULL_END
