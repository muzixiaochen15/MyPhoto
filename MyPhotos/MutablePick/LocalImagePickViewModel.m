//
//  LocalImagePickViewModel.m
//  YiQiXiu
//
//  Created by Sherry on 2019/4/30.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import "LocalImagePickViewModel.h"
#import "LocalImagePhotoInfo.h"
#import "SDAnimatedImage.h"

@implementation LocalImagePickViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self fetchImageOptionsSet];
    }
    return self;
}

- (BOOL)userHasChioceRightOfAccessPhotos { //用户是否进行过权限选择
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) { //用户还未进行选择
        [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)hasRightOfAccessPhotos {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }
}

- (void)startToRequestAllAblums {
    _albumsArray = [NSMutableArray array];
    
    //获取系统自定义的相册
    PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    [self fetchAblumInCollections:assetCollections];
    
    // 获得用户自定义相簿
    PHFetchResult<PHCollection *> *userCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    [self fetchAblumInCollections:userCollections];
    
    if (_allPhotoAblum) { //所有照片或者相机胶卷放在数组的第一位
        [_albumsArray removeObject:_allPhotoAblum];
        [_albumsArray insertObject:_allPhotoAblum atIndex:0];
    }
}

- (void)fetchAblumInCollections:(PHFetchResult *)assetCollections {
    PHFetchOptions *fetchResoultOption = [[PHFetchOptions alloc] init];
    fetchResoultOption.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    fetchResoultOption.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
    for (PHAssetCollection *collection in assetCollections) {
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHFetchResult *fetchR = [PHAsset fetchAssetsInAssetCollection:collection options:fetchResoultOption];
            if ([fetchR isKindOfClass:[PHFetchResult class]] && fetchR.count) {
                PhoneAblumInfo *ablumInfo = [[PhoneAblumInfo alloc] init];
                ablumInfo.ablumName = collection.localizedTitle;
                ablumInfo.ablumCount = fetchR.count;
                ablumInfo.ablum = fetchR;
                if (_allPhotoAblum.ablumCount < ablumInfo.ablumCount) {
                    _allPhotoAblum = ablumInfo;
                }
                [_albumsArray addObject:ablumInfo];
            }
        }
    }
}

#pragma mark 从相册中获取图片
- (void)fetchImageOptionsSet {
    //重要点：synchronous同步不设置，这时图片质量属性deliveryMode不生效，不设置
    if (_allPhotoOption == nil) {
        PHImageRequestOptions *allPhotoOption = [[PHImageRequestOptions alloc] init];
        //精准要求尺寸
        allPhotoOption.resizeMode = PHImageRequestOptionsResizeModeExact;
        //在速度与质量中均衡
        allPhotoOption.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        allPhotoOption.networkAccessAllowed = YES;  //允许使用网络，从iCLoud去拿图片
        _allPhotoOption = allPhotoOption;
    }
}

//从相册中获取图片
- (void)fectchPhotoWithIndex:(NSInteger)index
                     imgSize:(CGSize)size
                 finishBlock:(void(^)(UIImage *image))completion {
    if (_currentAblumInfo.ablum.count > index) {
        PHAsset *asset = [_currentAblumInfo.ablum objectAtIndex:index];
        if ([asset isKindOfClass:[PHAsset class]]) {
            BOOL needGifImage = NO;
            if (_needGif) {//需要动图
                if (@available(iOS 11, *)) {  //iOS 11以上才支持gif
                    if (asset.playbackStyle == PHAssetPlaybackStyleImageAnimated) { //是动图
                        needGifImage = YES;
                    }
                }
            }
            
            if (needGifImage) { //需要动图
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:_allPhotoOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    if (imageData.length / 1000 > 500) {  //大于500K,只取第一帧
                        UIImage *gifImage = [UIImage imageWithData:imageData scale:1.0];
                        if (completion) {
                            completion(gifImage);
                        }
                    } else {
                        if (imageData) {
                            SDAnimatedImage *gifImage = [[SDAnimatedImage alloc] initWithData:imageData];
                            if (completion) {
                                completion(gifImage);
                            }
                        }
                    }
                }];
            } else {  //静图
                if (size.width == 0) {
                    size.width = asset.pixelWidth;
                }
                if (size.height == 0) {
                    size.height = asset.pixelHeight;
                }
                CGFloat scaleRatio = MAX(size.width / asset.pixelWidth, size.height / asset.pixelHeight);
                CGFloat targetWidth = asset.pixelWidth * scaleRatio;
                CGFloat targetHeight = asset.pixelHeight * scaleRatio;
                CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
                
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:_allPhotoOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if ([result isKindOfClass:[UIImage class]]) {
                        if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
                            if (completion) {
                                completion(result);
                            }
                        }
                    } else {
                        if (completion) {
                            completion(nil);
                        }
                    }
                }];
            }
        } else {
            if (completion) {
                completion(nil);
            }
        }
    } else {
        if (completion) {
            completion(nil);
        }
    }
}

//从相册中获取封面
- (void)fectchAblumCoverPhotoWithImgSize:(CGSize)size finishBlock:(void(^)(void))completion {
    for (PhoneAblumInfo *ablumInfo in _albumsArray) {
        if (ablumInfo.ablum.count > 0) {
            PHAsset *asset = [ablumInfo.ablum objectAtIndex:0];
            if ([asset isKindOfClass:[PHAsset class]]) {
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:_allPhotoOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    if ([result isKindOfClass:[UIImage class]]) {
                        ablumInfo.ablumCoverImg = result;
                    }
                }];
            }
        }
    }
    completion();
}

//只用于多图选取，获取相册中index对应的图片asset
- (PHAsset *)fectchPhotoAssetWithIndex:(NSInteger)index {
    if (_currentAblumInfo.ablum.count > index) {
        PHAsset *asset = [_currentAblumInfo.ablum objectAtIndex:index];
        if ([asset isKindOfClass:[PHAsset class]]) {
            return asset;
        }
    }
    return nil;
}

//从相册中获取图片
- (void)fectchPhotoWithAsset:(PHAsset *)imgAsset
                     imgSize:(CGSize)size
                 finishBlock:(void(^)(UIImage *image))completion {
    if ([imgAsset isKindOfClass:[PHAsset class]]) {
        BOOL needGifImage = NO;
        if (_needGif) {//需要动图
            if (@available(iOS 11, *)) {  //iOS 11以上才支持gif
                if (imgAsset.playbackStyle == PHAssetPlaybackStyleImageAnimated) { //是动图
                    needGifImage = YES;
                }
            }
        }
        
        if (needGifImage) { //需要动图
            [[PHImageManager defaultManager] requestImageDataForAsset:imgAsset options:_allPhotoOption resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                if (imageData.length / 1000 > 500) {  //大于500K,只取第一帧
                    UIImage *gifImage = [UIImage imageWithData:imageData scale:1.0];
                    if (completion) {
                        completion(gifImage);
                    }
                } else {
                    if (imageData) {
                        SDAnimatedImage *gifImage = [[SDAnimatedImage alloc] initWithData:imageData];
                        if (completion) {
                            completion(gifImage);
                        }
                    }
                }
            }];
        } else {
            if (size.width == 0) {
                 size.width = imgAsset.pixelWidth;
             }
             if (size.height == 0) {
                 size.height = imgAsset.pixelHeight;
             }
            
             CGFloat scaleRatio = MAX(size.width / imgAsset.pixelWidth, size.height / imgAsset.pixelHeight);
             CGFloat  targetWidth = imgAsset.pixelWidth * scaleRatio;
             CGFloat targetHeight = imgAsset.pixelHeight * scaleRatio;
             CGSize targetSize = CGSizeMake(targetWidth, targetHeight);
             
             [[PHImageManager defaultManager] requestImageForAsset:imgAsset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:_allPhotoOption resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                 if (![[info objectForKey:PHImageResultIsDegradedKey] boolValue]) {
                     if ([result isKindOfClass:[UIImage class]]) {
                         if (completion) {
                             completion(result);
                         }
                     } else {
                         if (completion) {
                             completion(nil);
                         }
                     }
                 }
             }];
        }
    } else {
        if (completion) {
            completion(nil);
        }
    }
}

#pragma mark gif取第一帧
- (UIImage *)imageFromGifData:(NSData *)gifData {
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)gifData, nil);
    NSInteger count = CGImageSourceGetCount(source);
    if (count > 0) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, nil);
        UIImage *image = [UIImage imageWithCGImage: imageRef];
        // 清理，都是C指针，避免内存泄漏
        CGImageRelease(imageRef);
        CFRelease(source);
        return image;
    }
    CFRelease(source);
    return nil;
}



@end
