//
//  LocalMutableImgCollectionViewCell.h
//  YiQiXiu
//
//  Created by Sherry on 2019/8/22.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocalMutableImgCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic)UIImageView *imageView;
@property (strong, nonatomic)UIButton *selectBtn;
@property (assign, nonatomic)NSInteger hasSelect; //==-1 未进行过选择判断  ==1 已选中  ==0 为选中

@end

NS_ASSUME_NONNULL_END
