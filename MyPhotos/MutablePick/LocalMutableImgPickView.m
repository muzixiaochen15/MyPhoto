//
//  LocalMutableImgPickView.m
//  YiQiXiu
//
//  Created by Sherry on 2019/8/21.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import "LocalMutableImgPickView.h"
#import "LocalMutableImgCollectionViewCell.h"
#import "ConstantUI.h"
#import "AppDelegate.h"

@implementation LocalMutableImgPickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _minCount = 1;
        _isOpenAblum = YES;
        _selectInfoArray = [NSMutableArray array];
        
        //顶部
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0,0, frame.size.width, NAVIGATIONBAR_HEIGHT )];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        _topView = topView;
        
        UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, STATUS_BAR_HEIGHT, 80, NAVIGATIONBAR_HEIGHT - STATUS_BAR_HEIGHT);
        leftButton.titleLabel.font = [UIFont systemFontOfSize:kTitleSize];
        UIImage *image = [UIImage imageNamed:@"navBarReturn"];
        [leftButton setImage:image forState:UIControlStateNormal];
        [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 80 - image.size.width - 15)];
        leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [topView addSubview:leftButton];
        [leftButton addTarget:self action:@selector(leftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIImage *arrowImg = [UIImage imageNamed:@"photoDownArrowIcon"];
        UIButton *ablumSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnWidth = 150;
        ablumSelectBtn.frame = CGRectMake((frame.size.width - btnWidth) / 2 , STATUS_BAR_HEIGHT, btnWidth, NAVIGATIONBAR_HEIGHT - STATUS_BAR_HEIGHT);
        [topView addSubview:ablumSelectBtn];
        [ablumSelectBtn setTitleColor:[CommUtls changeToColorWithHexAndRgbString:@"#111111"] forState:UIControlStateNormal];
        ablumSelectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:kTitleSize];
        [ablumSelectBtn addTarget:self action:@selector(ablumSelectBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        _ablumSelectBtn = ablumSelectBtn;
        _ablumSelectBtn.hidden = YES;
        
        _arrowImageView = [[UIImageView alloc] initWithImage:arrowImg];
        _arrowImageView.frame = CGRectMake(btnWidth - arrowImg.size.width - 25, 0, arrowImg.size.width, ablumSelectBtn.frame.size.height);
        [ablumSelectBtn addSubview:_arrowImageView];
        _arrowImageView.contentMode = UIViewContentModeCenter;
    }
    return self;
}

- (void)leftButtonOnClick {
    if (self.delegate && [self.delegate respondsToSelector:@selector(leftButtonOnClick)]) {
        [self.delegate leftButtonOnClick];
    }
}

- (void)collectionAndBottomViewInit {
    CGFloat bottomHeight ;
    if (_needSort) {
        bottomHeight = 160;
    } else {
        bottomHeight = 50;
    }
    _itemWidth = (self.frame.size.width - 10) / 3;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(_itemWidth, _itemWidth);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    _imgCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, NAVIGATIONBAR_HEIGHT, self.frame.size.width, self.frame.size.height - bottomHeight - NAVIGATIONBAR_HEIGHT) collectionViewLayout:flowLayout];
    _imgCollectView.backgroundColor = [UIColor clearColor];
    [self addSubview:_imgCollectView];
    _imgCollectView.delegate = self;
    _imgCollectView.dataSource = self;
    [_imgCollectView registerClass:[LocalMutableImgCollectionViewCell class] forCellWithReuseIdentifier:@"LocalMutableImgCollectionViewCell"];
    
    //底部
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - bottomHeight, self.frame.size.width, bottomHeight)];
    [self addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];

    CGFloat btnOrginY = 14;
    CGFloat btnHeight ;
    if (_needSort) {
        btnHeight = 32;
    } else {
        btnHeight = bottomHeight - btnOrginY * 2;
    }
    CGFloat alertLabelHeight ;
    if (_needSort) {
        alertLabelHeight = btnHeight / 2;
    } else {
        alertLabelHeight = btnHeight ;
    }
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, btnOrginY,self.frame.size.width , alertLabelHeight)];
    alertLabel.textColor = [CommUtls changeToColorWithHexAndRgbString:kBlackColorStr2];
    alertLabel.font = [UIFont boldSystemFontOfSize:kContentSize];
    [bottomView addSubview:alertLabel];
    if (_maxCount == _minCount) {
        alertLabel.text = [NSString stringWithFormat:@"请选择%ld张图片",_maxCount];
    } else {
        alertLabel.text = [NSString stringWithFormat:@"请选择%ld-%ld张图片",_minCount,_maxCount];
    }
    _alertLabel = alertLabel;
    
    //确定按钮
    _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureButton.frame = CGRectMake(self.frame.size.width - 16 - 70, btnOrginY,70,btnHeight);
    _sureButton.layer.cornerRadius = btnHeight / 2.0;
    [_sureButton addTarget:self action:@selector(chooseImageFinish) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:_sureButton];
    CAGradientLayer *gradientLayer = [CommUtls getGradientLayerWithColors:@[@"#49AAFE",@"#0093FF"] withSize:CGSizeMake(70, btnHeight)];
    gradientLayer.cornerRadius = btnHeight / 2.0;
    [_sureButton.layer addSublayer:gradientLayer];
    
    _sureLabel = [[UILabel alloc]initWithFrame:_sureButton.bounds];
    _sureLabel.font = [UIFont boldSystemFontOfSize:kContentSize];
    _sureLabel.backgroundColor = [UIColor clearColor];
    _sureLabel.textColor = [UIColor whiteColor];
    _sureLabel.layer.cornerRadius = btnHeight / 2.0;
    _sureLabel.textAlignment = NSTextAlignmentCenter;
    if (_isFromStitchPic) {
        _sureLabel.text = @"拼图";
    }else{
        _sureLabel.text = @"确定";
    }
    [_sureButton addSubview:_sureLabel];
    
    if (_needSort) {
        UILabel *desLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, alertLabel.frame.origin.y + alertLabelHeight + 4,self.frame.size.width , alertLabelHeight)];
        desLabel.textColor = [CommUtls changeToColorWithHexAndRgbString:kBlockColorStr9];
        desLabel.font = [UIFont systemFontOfSize:kDetailSize];
        [bottomView addSubview:desLabel];
        desLabel.text = @"长按可拖动图片顺序";
        
        CGFloat collOrginY = desLabel.frame.origin.y + alertLabelHeight + 5;
        _selectCollection = [[SelectImageCollectionView alloc] initWithFrame:CGRectMake(0,collOrginY, self.frame.size.width, bottomHeight - collOrginY - 5)];
        [bottomView addSubview:_selectCollection];
        _selectCollection.photoNowShowSize = CGSizeMake(_itemWidth * 2, _itemWidth * 2);
        _selectCollection.sortImgArray = _selectInfoArray;
        __weak typeof(self) weakSelf = self;
        _selectCollection.deleteBlock = ^(NSString * _Nonnull indenter) {// 取消选中
            for (int i = 0; i < weakSelf.photoInfoArray.count; i++) {
                LocalImagePhotoInfo *imgInfo = [weakSelf.photoInfoArray objectAtIndex:i];
                if ([imgInfo.localIndenter isEqualToString:indenter]) {
                    LocalMutableImgCollectionViewCell *cell = (LocalMutableImgCollectionViewCell *)[weakSelf.imgCollectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    if (cell) {//可见区cell
                        [weakSelf selectBtnButtonOnClick:cell.selectBtn];
                    }else{//非可见区，只刷数据
                        [weakSelf updateInvisibleCellWithInfo:imgInfo];
                    }
                    break;
                }
            }
        };
    }
}

// 点击❎，取消选中
- (void)updateInvisibleCellWithInfo:(LocalImagePhotoInfo *)imgInfo{
    imgInfo.hasSelect = kLocalImgSelectStateNo;
    if (self.isFromStitchPic) {
        _sureLabel.text = [NSString stringWithFormat:@"拼图(%ld)",_selectInfoArray.count];
    }else{
        _sureLabel.text = [NSString stringWithFormat:@"确定(%ld)",_selectInfoArray.count];
    }
}

- (void)showAlbumsAndPhotos {
    if (![_localImgViewModel userHasChioceRightOfAccessPhotos]) {
        [self performSelector:@selector(showAlbumsAndPhotos) withObject:nil afterDelay:1.0];
        return;
    }
    
    if ([_localImgViewModel hasRightOfAccessPhotos]) { //有相册权限
        [_localImgViewModel startToRequestAllAblums]; //获取相册数组
        if (_localImgViewModel.albumsArray.count > 0) {
            _ablumSelectBtn.hidden = NO;
            PhoneAblumInfo *ablumInfo = _localImgViewModel.albumsArray.firstObject;
            [self collectionAndBottomViewInit];
            [self showPhotosInAblum:ablumInfo];
        }
    } else { //无相册访问权限
        UILabel *noRightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, 50)];
        noRightLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:noRightLabel];
        noRightLabel.font = [UIFont systemFontOfSize:kTitleSize];
        noRightLabel.textColor = [CommUtls changeToColorWithHexAndRgbString:kBlackColorStr2];
        noRightLabel.text = @"请在iPhone的\"设置-隐私-照片\"选项中，\n允许“易企秀”访问你的手机相册";
        noRightLabel.numberOfLines = 2;
    }
}

- (void)showPhotosInAblum:(PhoneAblumInfo *)ablumInfo {
    [_ablumSelectBtn setTitle:ablumInfo.ablumName forState:UIControlStateNormal];
    _localImgViewModel.currentAblumInfo = ablumInfo;
    
    if (_photoInfoArray == nil) {
        _photoInfoArray = [NSMutableArray array];
    } else {
        [_photoInfoArray removeAllObjects];
    }
    for (PHAsset *asset in ablumInfo.ablum) {
        LocalImagePhotoInfo *localImgInfo = [[LocalImagePhotoInfo alloc] init];
        localImgInfo.asset = asset;
        localImgInfo.localIndenter = asset.localIdentifier;
        [_photoInfoArray addObject:localImgInfo];
    }   //每次相册变更，需要重新给cell的图片赋值info
    
    [_imgCollectView reloadData];
    [_imgCollectView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:(UICollectionViewScrollPositionTop) animated:NO];
}

//垂直线
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//水平线
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 5.0f;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LocalMutableImgCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LocalMutableImgCollectionViewCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (row < _photoInfoArray.count) {
        cell.selectBtn.tag = indexPath.row + 1000;
        [cell.selectBtn addTarget:self action:@selector(selectBtnButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        LocalImagePhotoInfo *imgInfo = [_photoInfoArray objectAtIndex:row];
        if (imgInfo.thumImg) {
            cell.imageView.image = imgInfo.thumImg;
        } else {
            [_localImgViewModel fectchPhotoWithAsset:imgInfo.asset imgSize:CGSizeMake(_itemWidth * 2, _itemWidth * 2) finishBlock:^(UIImage * _Nonnull image) {
                if (image) {
                    cell.imageView.image = image;
                    imgInfo.thumImg = image;
                }
            }];
        }
        
        if (imgInfo.hasSelect == kLocalImgSelectStateNone) {//表示未判断过选取
            imgInfo.hasSelect = [self judgeImgHasSelect:imgInfo];
        }
        if (imgInfo.hasSelect == kLocalImgSelectStateNo) {
            [self resetSelectButtonImg:NO btn:cell.selectBtn];
        } else {
            [self resetSelectButtonImg:YES btn:cell.selectBtn];
        }
    }
    return cell;
}

- (LocalImgMutableSelectState)judgeImgHasSelect:(LocalImagePhotoInfo *)showInfo {
    LocalImgMutableSelectState selectState = kLocalImgSelectStateNo;
    for (LocalImagePhotoInfo *photoInfo in _selectInfoArray) {
        if ([photoInfo.localIndenter isEqualToString:showInfo.localIndenter]) {
            selectState = kLocalImgSelectStateYes;
            break;
        }
    }
    return selectState;
}

- (void)resetSelectButtonImg:(BOOL)hasSelect btn:(UIButton *)selectBtn {
    if (hasSelect) {
        [selectBtn setImage:[UIImage imageNamed:@"Photo_Pre_select"] forState:UIControlStateNormal];
    } else {
        [selectBtn setImage:[UIImage imageNamed:@"Photo_pre_unselect"] forState:UIControlStateNormal];
    }
}

#pragma mark 按钮点击-展示相册列表
- (void)ablumSelectBtnOnClick {
    if (_isOpenAblum) {
        [self abumTableViewWillShow:YES];
        [UIView animateWithDuration:0.3f animations:^{
            self->_ablumView.frame = self->_ablumViewFrame;
            self->_ablumBackView.alpha = 0.5;
            self->_arrowImageView.image = [UIImage imageNamed:@"photoUpArrowIcon"];
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self->_ablumView.frame = CGRectMake(0, -(self->_ablumViewFrame.size.height)  ,self->_ablumViewFrame.size.width , self->_ablumViewFrame.size.height);
            self->_ablumBackView.alpha = 0;
            self->_arrowImageView.image = [UIImage imageNamed:@"photoDownArrowIcon"];
        } completion:^(BOOL finished) {
            [self abumTableViewWillShow:NO];
        }];
    }
    _isOpenAblum = !_isOpenAblum;
}

- (void)abumTableViewWillShow:(BOOL)isShow {
    if (_ablumView == nil) {
        __weak typeof(self) weakSelf = self;
        [_localImgViewModel fectchAblumCoverPhotoWithImgSize:CGSizeMake(_itemWidth, _itemWidth) finishBlock:^{
            [weakSelf localImageAblumViewInit];
        }];
    } else {
        if (isShow) {
            [self addSubview:_ablumBackView];
            [self addSubview:_ablumView];
            [self bringSubviewToFront:_topView];
        } else {
            [_ablumView removeFromSuperview];
            [_ablumBackView removeFromSuperview];
        }
    }
}

- (void)localImageAblumViewInit {
    CGFloat originY = _imgCollectView.frame.origin.y;
    _ablumBackView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, self.frame.size.width, self.frame.size.height - originY)];
    _ablumBackView.backgroundColor = [UIColor blackColor];
    [self addSubview:_ablumBackView];
    _ablumBackView.alpha = 0;
    UIControl *removeControl = [[UIControl alloc] initWithFrame:_ablumBackView.bounds];
    [removeControl addTarget:self action:@selector(removeAblumView) forControlEvents:UIControlEventTouchUpInside];
    [_ablumBackView addSubview:removeControl];
    
    _ablumViewFrame = CGRectMake(0, originY, self.frame.size.width, self.frame.size.height / 2 + 20);
    _ablumView = [[LocalAblumImageTableView alloc] initWithFrame:CGRectMake(0, -(_ablumViewFrame.size.height)  ,_ablumViewFrame.size.width , _ablumViewFrame.size.height)];
    _ablumView.ablumViewDelegate = self;
    _ablumView.ablumArray = _localImgViewModel.albumsArray;
    [self addSubview:_ablumView];
    [self bringSubviewToFront:_topView];
}

- (void)ablumOnClick:(NSInteger)index {
    if (_localImgViewModel.albumsArray.count > index) {
        PhoneAblumInfo *ablumInfo = [_localImgViewModel.albumsArray objectAtIndex:index];
        if ([_localImgViewModel.currentAblumInfo.ablumName isEqualToString:ablumInfo.ablumName] && _localImgViewModel.currentAblumInfo.ablumCount == ablumInfo.ablumCount ) {
            [self ablumSelectBtnOnClick];
            return;
        }
        [self showPhotosInAblum:ablumInfo];
        [self ablumSelectBtnOnClick];
    }
}

- (void)selectBtnButtonOnClick:(UIButton *)button {
    NSInteger index = button.tag - 1000;
    LocalMutableImgCollectionViewCell *cell = (LocalMutableImgCollectionViewCell *)[_imgCollectView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if ([cell isKindOfClass:[LocalMutableImgCollectionViewCell class]]) {
        if (index < _photoInfoArray.count) {
            LocalImagePhotoInfo *info = [_photoInfoArray objectAtIndex:index];
            if (info.hasSelect == kLocalImgSelectStateYes) {//表示已选中
                for (LocalImagePhotoInfo *selectInfo in _selectInfoArray) {
                    if ([selectInfo.localIndenter isEqualToString:info.localIndenter]) {
                        [_selectInfoArray removeObject:selectInfo]; //找到已选择的图片info删除
                        break;
                    }
                }
                [self resetSelectButtonImg:NO btn:cell.selectBtn];
                info.hasSelect = kLocalImgSelectStateNo;
            } else {//正在选中
                if (_selectInfoArray.count >= _maxCount) {
                    [[AppDelegate getAppDelegate] showFailedActivityView:[NSString stringWithFormat:@"最多可选择%ld张图片",_maxCount] interval:1.0];
                    return;
                }
                if (info) {
                    [_selectInfoArray addObject:info];
                }
                [self resetSelectButtonImg:YES btn:cell.selectBtn];
                info.hasSelect = kLocalImgSelectStateYes;
            }
        }
    }
    [_selectCollection collectionViewReloadData];
    if (_isFromStitchPic) {
        _sureLabel.text = [NSString stringWithFormat:@"拼图(%ld)",_selectInfoArray.count];
    }else{
        _sureLabel.text = [NSString stringWithFormat:@"确定(%ld)",_selectInfoArray.count];
    }
}

- (void)removeAblumView {
    [self ablumSelectBtnOnClick];
}

- (void)chooseImageFinish {
    if (_selectInfoArray.count < _minCount) {
        [[AppDelegate getAppDelegate] showFailedActivityView:[NSString stringWithFormat:@"请最少选择%ld张图片",_minCount] interval:1.0];
        return;
    }
    if (self.delegate) {
        [self.delegate chooseLocalImageFinish];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
