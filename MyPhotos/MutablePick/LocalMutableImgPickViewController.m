//
//  LocalMutableImgPickViewController.m
//  YiQiXiu
//
//  Created by Sherry on 2019/8/21.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import "LocalMutableImgPickViewController.h"
#import "LocalMutableImgPickView.h"
#import "AppDelegate.h"

@interface LocalMutableImgPickViewController () <LocalMutableImgPickViewDelegate>

@property (strong, nonatomic)LocalMutableImgPickView *imgPickerView;

@end

@implementation LocalMutableImgPickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (_minCount == 0) {
        _minCount = 1;
    }
    if (_needOrginPhoto) { //需要原图
        _photoSize = CGSizeMake(0, 0);
    } else {
        if (_photoSize.width == 0) {
            _photoSize.width = 828;
        }
        if (_photoSize.height == 0) {
            _photoSize.height = 1374;
        }
    }
    
    _imgPickerView = [[LocalMutableImgPickView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _imgPickerView.delegate = self;
    _imgPickerView.maxCount = _maxCount;
    _imgPickerView.minCount = _minCount;
    _imgPickerView.needSort = _needSortImg;
    _imgPickerView.isFromStitchPic = _isFromStitchPic;
    LocalImagePickViewModel *viewModel = [[LocalImagePickViewModel alloc] init];
    viewModel.isMutableSelect = YES;
    viewModel.needGif = _needSupportGif;
    _imgPickerView.localImgViewModel = viewModel;
    _imgPickerView.needBrowsePhoto = _needBrowsePhoto;
    [self.view addSubview:_imgPickerView];
    [_imgPickerView showAlbumsAndPhotos];
}

- (void)leftButtonOnClick {
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshLongPageNoDataView" object:nil];
}

- (void)chooseLocalImageFinish {
    NSMutableDictionary *selectImgDic = [NSMutableDictionary dictionary];
    
    NSInteger selectCount = _imgPickerView.selectInfoArray.count;
    __block NSInteger hasQueryImgCount = 0;
    __weak typeof(self) weakSelf = self;
    for (NSInteger i = 0; i < selectCount; i++) {
        LocalImagePhotoInfo *info = [_imgPickerView.selectInfoArray objectAtIndex:i];
        [_imgPickerView.localImgViewModel fectchPhotoWithAsset:info.asset imgSize:_photoSize finishBlock:^(UIImage * _Nonnull image) {
            if (image) {
                [selectImgDic setObject:image forKey:[NSNumber numberWithInteger:i]];
            }
            hasQueryImgCount++;
            if (hasQueryImgCount == selectCount) {
                [weakSelf sendBlockWithDic:selectImgDic];
            }
        }];
    }
}

- (void)sendBlockWithDic:(NSDictionary *)selectDic {
    NSArray *allKeys = selectDic.allKeys;
    NSArray *sortedArray = [allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2]; //升序
    }];
    
    NSMutableArray *imgArray = [NSMutableArray array];
    for (id key in sortedArray) {
        UIImage *img = [selectDic objectForKey:key];
        if ([img isKindOfClass:[UIImage class]]) {
            [imgArray addObject:img];
        }
    }

    if (imgArray.count > 0 && self.finishBlock) {
        self.finishBlock(imgArray);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
