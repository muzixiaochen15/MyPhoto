//
//  SelectImageCollectionView.m
//  YiQiXiu
//
//  Created by Sherry on 2019/9/24.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import "SelectImageCollectionView.h"
#import "SelectImageCollectionViewCell.h"
#import "LocalImagePhotoInfo.h"

@implementation SelectImageCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(frame.size.height , frame.size.height );
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;

        _selectCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height ) collectionViewLayout:flowLayout];
        _selectCollection.backgroundColor = [UIColor whiteColor];
        [self addSubview:_selectCollection];
        _selectCollection.delegate = self;
        _selectCollection.dataSource = self;
        [_selectCollection registerClass:[SelectImageCollectionViewCell class] forCellWithReuseIdentifier:@"SelectImageCollectionViewCell"];
         UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lonePressMoving:)];
        [_selectCollection addGestureRecognizer:longPress];
        _selectCollection.showsHorizontalScrollIndicator = NO;
        _longPress = longPress;
        
        LocalImagePickViewModel *viewModel = [[LocalImagePickViewModel alloc] init];
        _viewModel = viewModel;
    }
    return self;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _sortImgArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectImageCollectionViewCell" forIndexPath:indexPath];
    NSInteger row = indexPath.row;
    if (row < _sortImgArray.count) {
        LocalImagePhotoInfo *info = [_sortImgArray objectAtIndex:row];
        cell.imgView.image = info.thumImg;
        cell.imgView.transform = CGAffineTransformIdentity;
        
        cell.deleteBtn.tag = indexPath.row + 1000;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (void)lonePressMoving:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *selectIndexPath = [_selectCollection indexPathForItemAtPoint:[longPress locationInView:_selectCollection]];
            // 找到当前的cell
            SelectImageCollectionViewCell *cell = (SelectImageCollectionViewCell *)[_selectCollection cellForItemAtIndexPath:selectIndexPath];
            cell.imgView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
            [_selectCollection beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [_selectCollection updateInteractiveMovementTargetPosition:[longPress locationInView:longPress.view]];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            NSIndexPath *selectIndexPath = [_selectCollection indexPathForItemAtPoint:[longPress locationInView:_selectCollection]];
            SelectImageCollectionViewCell *cell = (SelectImageCollectionViewCell *)[_selectCollection cellForItemAtIndexPath:selectIndexPath];
            cell.imgView.transform = CGAffineTransformIdentity;
            [_selectCollection endInteractiveMovement];
            [self performSelector:@selector(collectionViewReloadData) withObject:nil afterDelay:0.5];
            break;
        }
        default: {
            NSIndexPath *selectIndexPath = [_selectCollection indexPathForItemAtPoint:[longPress locationInView:_selectCollection]];
            SelectImageCollectionViewCell *cell = (SelectImageCollectionViewCell *)[_selectCollection cellForItemAtIndexPath:selectIndexPath];
            cell.imgView.transform = CGAffineTransformIdentity;
            [_selectCollection cancelInteractiveMovement];
        }
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {
    id asset = [_sortImgArray objectAtIndex:sourceIndexPath.row];
    [_sortImgArray removeObject:asset];
    [_sortImgArray insertObject:asset atIndex:destinationIndexPath.row];
}

- (void)collectionViewReloadData {
    [UIView animateWithDuration:0 animations:^{
        [_selectCollection reloadData];
    } completion:^(BOOL finished) {
    }];
}

- (void)deleteBtnClicked:(UIButton *)button{
    NSInteger index = button.tag - 1000;
    if (index >= 0&&index < _sortImgArray.count) {
        LocalImagePhotoInfo *info = [_sortImgArray objectAtIndex:index];
        [_sortImgArray removeObjectAtIndex:index];
        [self collectionViewReloadData];
        if (_deleteBlock) {
            _deleteBlock(info.localIndenter);
        }
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
