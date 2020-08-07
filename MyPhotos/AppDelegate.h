//
//  AppDelegate.h
//  MyPhotos
//
//  Created by 李群 on 2020/8/6.
//  Copyright © 2020 李群. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

+ (AppDelegate *)getAppDelegate;
// first show hud with text
- (void)showActivityView:(NSString *)text;
// first show hud with text in view
- (void)showActivityView:(NSString *)text inView:(UIView *)view;
// hide prevoiusly showed hud
- (void)hideActivityView;
- (void)hideActivityView:(BOOL)animated;
// first showe hud with succeed text and image for time seconds
- (void)showFailedActivityView:(NSString *)text interval:(NSTimeInterval)time;

@end

