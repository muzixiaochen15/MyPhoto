//
//  LocalImagePhotoInfo.m
//  YiQiXiu
//
//  Created by Sherry on 2019/4/30.
//  Copyright © 2019 Sherry. All rights reserved.
//

#import "LocalImagePhotoInfo.h"

@implementation LocalImagePhotoInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        _hasSelect = kLocalImgSelectStateNone;
    }
    return self;
}

@end
