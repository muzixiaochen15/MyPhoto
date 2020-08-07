//
//  LocalImagePickViewModel.h
//  YiQiXiu
//
//  Created by Sherry on 2019/4/30.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "PhoneAblumInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalImagePickViewModel : NSObject {
    PhoneAblumInfo *_allPhotoAblum;  //所有照片相册
    PHImageRequestOptions *_allPhotoOption;
}

@property (strong, nonatomic)NSMutableArray *albumsArray;
@property (strong, nonatomic)PhoneAblumInfo *currentAblumInfo;
@property (assign, nonatomic)BOOL photoSize;
@property (assign, nonatomic)BOOL isMutableSelect;
@property (assign, nonatomic)BOOL needGif;

- (BOOL)userHasChioceRightOfAccessPhotos;
- (BOOL)hasRightOfAccessPhotos;
- (void)startToRequestAllAblums;

- (void)fectchPhotoWithIndex:(NSInteger)index
                     imgSize:(CGSize)size
                 finishBlock:(void(^)(UIImage *image))completion;
- (void)fectchAblumCoverPhotoWithImgSize:(CGSize)size finishBlock:(void(^)(void))completion;

//只用于多图选取，获取相册中index对应的图片asset
- (PHAsset *)fectchPhotoAssetWithIndex:(NSInteger)index;
- (void)fectchPhotoWithAsset:(PHAsset *)imgAsset
                     imgSize:(CGSize)size
                 finishBlock:(void(^)(UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
