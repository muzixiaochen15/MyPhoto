//
//  LocalMutableImgPickView.h
//  YiQiXiu
//
//  Created by Sherry on 2019/8/21.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalImagePickViewModel.h"
#import "LocalAblumImageTableView.h"
#import "SelectImageCollectionView.h"
#import "LocalImagePhotoInfo.h"

@protocol LocalMutableImgPickViewDelegate <NSObject>

- (void)leftButtonOnClick;
- (void)chooseLocalImageFinish;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LocalMutableImgPickView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,LocalImageAblumViewDelegate> {
    CGFloat _itemWidth;
    UILabel *_alertLabel;
    UIButton *_sureButton;
    UILabel *_sureLabel;
    UIButton *_ablumSelectBtn;
    UIImageView *_arrowImageView;
    BOOL _isOpenAblum;
    LocalAblumImageTableView *_ablumView;
    CGRect _ablumViewFrame;
    UIView *_ablumBackView;
    UIView *_topView;
}

@property (strong, nonatomic)UICollectionView *imgCollectView;
@property (strong, nonatomic)SelectImageCollectionView *selectCollection;
@property (strong, nonatomic)LocalImagePickViewModel *localImgViewModel;
@property (weak, nonatomic)id<LocalMutableImgPickViewDelegate>delegate;

@property (assign, nonatomic)BOOL needSort;
@property (assign, nonatomic)BOOL needBrowsePhoto;
@property (assign, nonatomic)NSInteger maxCount;
@property (assign, nonatomic)NSInteger minCount;
@property (strong, nonatomic)NSMutableArray *selectInfoArray;
@property (strong, nonatomic)NSMutableArray *photoInfoArray;
// 来自拼图
@property (nonatomic, assign) BOOL isFromStitchPic;


- (void)showAlbumsAndPhotos ;
@end

NS_ASSUME_NONNULL_END
