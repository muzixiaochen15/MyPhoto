//
//  SelectImageCollectionView.h
//  YiQiXiu
//
//  Created by Sherry on 2019/9/24.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalImagePickViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 删除选中图片 */
typedef void(^DeleteSelectedImageBlock)(NSString *indenter);

@interface SelectImageCollectionView : UIView<UICollectionViewDelegate,UICollectionViewDataSource> {
    UILongPressGestureRecognizer *_longPress;
    
}

@property (strong, nonatomic)UICollectionView *selectCollection;
@property (strong, nonatomic)NSMutableArray *sortImgArray;
@property (assign, nonatomic)CGSize photoNowShowSize;  //与列表用相同的尺寸，因为系统有缓存
@property (strong, nonatomic)LocalImagePickViewModel *viewModel;
// 删除图片
@property (copy, nonatomic)DeleteSelectedImageBlock deleteBlock;

- (void)collectionViewReloadData;

@end

NS_ASSUME_NONNULL_END
