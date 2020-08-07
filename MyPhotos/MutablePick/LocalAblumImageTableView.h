//
//  LocalAblumImageTableView.h
//  YiQiXiu
//
//  Created by Sherry on 2019/8/24.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  LocalImageAblumViewDelegate <NSObject>

- (void)ablumOnClick:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface LocalAblumImageTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)NSArray *ablumArray;
@property (weak, nonatomic)id<LocalImageAblumViewDelegate>ablumViewDelegate;

@end

NS_ASSUME_NONNULL_END
