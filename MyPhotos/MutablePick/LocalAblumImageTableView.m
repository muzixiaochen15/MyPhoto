//
//  LocalAblumImageTableView.m
//  YiQiXiu
//
//  Created by Sherry on 2019/8/24.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import "LocalAblumImageTableView.h"
#import "LocalAlbumCell.h"
#import "PhoneAblumInfo.h"

@implementation LocalAblumImageTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ablumArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"EasyFormTopicCell";
    LocalAlbumCell *cell = (LocalAlbumCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[LocalAlbumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSInteger row = indexPath.row;
    NSInteger allCount = [_ablumArray count];
    if (allCount > row) {
        PhoneAblumInfo *ablumInfo = [_ablumArray objectAtIndex:row];
        cell.albumImageView.image = ablumInfo.ablumCoverImg;
        cell.albumTitleLabel.text = ablumInfo.ablumName;
        cell.albumPhotoNumLabel.text = [NSString stringWithFormat:@"%ld张",(long)ablumInfo.ablumCount];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.ablumViewDelegate && [self.ablumViewDelegate respondsToSelector:@selector(ablumOnClick:)]) {
        [self.ablumViewDelegate ablumOnClick:indexPath.row];
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
