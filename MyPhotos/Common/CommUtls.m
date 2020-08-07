//
//  CommUtls.m
//  UtlBox
//
//  Created by cdel cyx on 12-7-10.
//  Copyright (c) 2012年 cdeledu. All rights reserved.
//

#import "CommUtls.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>
#import <sys/utsname.h>
#import "EQXConstantUrl.h"
#import <AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface CommUtls() <CAAnimationDelegate>

#else
@interface CommUtls()

#endif
@end

@implementation CommUtls

//根据info属性名赋值
+ (NSObject *)initPropertyWithClass:(NSObject *)infoObject fromDic:(NSDictionary *)jsonDic
{
    if ([jsonDic isKindOfClass:[NSDictionary class]] && jsonDic.count > 0) {
        unsigned int outCount ;
        objc_property_t *properties = class_copyPropertyList([infoObject class], &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            const char *propertyName = property_getName(property);
            NSString *propertyNameStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            id valueObj = [jsonDic valueForKey:propertyNameStr];
            if (![valueObj isKindOfClass:[NSNull class]] && valueObj != nil) {
                if ([valueObj isKindOfClass:[NSObject class]]) {
                    [infoObject setValue:valueObj forKey:propertyNameStr];
                }
            }
        }
        free(properties);
        
        if (![NSStringFromClass(infoObject.superclass) isEqualToString:@"NSObject"]) {//表示有继承
            unsigned int superOutCount ;
            objc_property_t *superProperties = class_copyPropertyList(infoObject.superclass, &superOutCount);
            for (int i = 0; i < superOutCount; i++) {
                objc_property_t superProperty = superProperties[i];
                const char *superPropertyName = property_getName(superProperty);
                NSString *superPropertyNameStr = [NSString stringWithCString:superPropertyName encoding:NSUTF8StringEncoding];
                id valueObj = [jsonDic valueForKey:superPropertyNameStr];
                if (![valueObj isKindOfClass:[NSNull class]] && valueObj != nil) {
                    if ([valueObj isKindOfClass:[NSObject class]]) {
                        [infoObject setValue:valueObj forKey:superPropertyNameStr];
                    }
                }
            }
            free(superProperties);
        }
    }
    return infoObject;
}

//根据属性名把sourceObject的值赋值给infoObject相同的属性值
+ (void)initPropertyWithClass:(NSObject *)infoObject fromClass:(NSObject *)sourceObject {
    if (sourceObject && infoObject) {
        unsigned int outCount ;
        unsigned int outCountSuper = 0;
        objc_property_t *superProperties = nil;
        objc_property_t *properties = class_copyPropertyList([infoObject class], &outCount);
    
        if (![NSStringFromClass(infoObject.superclass) isEqualToString:@"NSObject"]) {
            superProperties = class_copyPropertyList(infoObject.superclass, &outCountSuper);
        }
        
        for (int i = 0; i < outCount + outCountSuper; i++) {
            objc_property_t property ;
            if (i < outCount) {
                property = properties[i];
            } else {
                property = superProperties[i - outCount];
            }

            const char *propertyName = property_getName(property);
            NSString *propertyNameStr = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
            NSString *propertyNameHasPreStr = [NSString stringWithFormat:@"_%@",propertyNameStr];
            const char *propertyNameHasPre = [propertyNameHasPreStr UTF8String];//有前缀的属性值name
            Ivar ivar = class_getInstanceVariable([sourceObject class], propertyNameHasPre);
            if (ivar) { //源class里有该属性值
                id valueObj = [sourceObject valueForKey:propertyNameStr];
                if (![valueObj isKindOfClass:[NSNull class]] && valueObj != nil) {
                    if ([valueObj isKindOfClass:[NSObject class]]) {
                        [infoObject setValue:valueObj forKey:propertyNameStr];
                    }
                }
            } else {//ivar为空，还有可能是父类的属性值
                if (![NSStringFromClass(sourceObject.superclass) isEqualToString:@"NSObject"]) { //ivar为空的时候，取父类的属性值
                    ivar = class_getInstanceVariable(sourceObject.superclass, propertyNameHasPre);
                    if (ivar) { //源class里有该属性值
                        id valueObj = [sourceObject.superclass valueForKey:propertyNameStr];
                        if (![valueObj isKindOfClass:[NSNull class]] && valueObj != nil) {
                            if ([valueObj isKindOfClass:[NSObject class]]) {
                                [infoObject setValue:valueObj forKey:propertyNameStr];
                            }
                        }
                    }
                }
            }
        }
        free(properties);
    }
}

+ (UIColor *)randomColorForImageBack {
    NSString *randomColorStr = [self getRandomColorString];
    UIColor *randomColor = [self changeToColorWithHexAndRgbString:randomColorStr];
    return randomColor;
}

+ (NSString *)getRandomColorString {
    int randomColorIndex = arc4random()% 10;
    NSArray *colorArray = [NSArray arrayWithObjects:@"#ceecff",@"#e7fff1",@"#eeebff",@"#f6ffeb",@"#ffe7e7",@"#dfe7ff",@"#f7ffe7",@"#ffdadb",@"#ebfffd",@"#fff1e7",@"#f6ffeb", nil];
    if (colorArray.count > randomColorIndex) {
        return [colorArray objectAtIndex:randomColorIndex];
    }
    return @"";
}

+ (NSInteger)getEqAdTypeWithSceneInfo:(NSString *)propertyStr {
    if ([propertyStr isKindOfClass:[NSString class]]) {
        NSDictionary *propertyDic = [NSJSONSerialization
                                     JSONObjectWithData:[propertyStr dataUsingEncoding:NSUTF8StringEncoding]
                                     options:0
                                     error:nil];
        if ([propertyDic isKindOfClass:[NSDictionary class]] &&
            [propertyDic count] > 0 && [propertyDic valueForKey:@"eqAdType"] != nil) {
            return [[propertyDic objectForKey:@"eqAdType"] integerValue];
        }
    }
    return 1;
}

/**
 获取用户是否绑定手机号
 */
+(BOOL)getUserIfIsBinded {
    BOOL isBind = NO;
    id phoneObj = [[NSUserDefaults standardUserDefaults] objectForKey:@"quickPhone"];
    NSString *phoneStr;
    if ([phoneObj isKindOfClass:[NSString class]]) {
        phoneStr = (NSString *)phoneObj;
        if (phoneStr == (id)[NSNull null] || phoneStr.length == 0)   {
            isBind = NO;
        } else {
            isBind = YES;
        }
    } else {
        isBind = NO;
    }
    return isBind;
}

/**
 获取用户是否关联手机号
 */
+(BOOL)getUserIfIsRelatedPhone {
    BOOL isBind = NO;
    id phoneObj = [[NSUserDefaults standardUserDefaults] objectForKey:@"relatePhone"];
    NSString *phoneStr;
    if ([phoneObj isKindOfClass:[NSString class]]) {
        phoneStr = (NSString *)phoneObj;
        if ([phoneStr isEqualToString:@"yes"])   {
            isBind = YES;
        } else {
            isBind = NO;
        }
    } else {
        isBind = NO;
    }
    return isBind;
}

/**
 *	@brief	创建文件夹
 *
 *	@param 	dir 	文件夹名字
 */
+ (void)makeDirs:(NSString *)dir {
    //创建文件夹
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if (![file_manager fileExistsAtPath:dir]) {
        [file_manager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

/**
 *	@brief	离现在时间相差时间
 *
 *	@param 	date 	时间格式
 *
 *	@return	返回字符串
 */
+ (NSString *)timeSinceNowWithDateStr:(NSDate *)date {
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeInterval interval = 0 - [date timeIntervalSinceNow];
        
        if (interval < 60) { // 几秒前
            return @"1分钟内";
        } else if (interval < (60 * 60)) { // 几分钟前
            return [NSString stringWithFormat:@"%u分钟前", (int)(interval / 60)];
        } else if (interval < (24 * 60 * 60)) { // 几小时前
            return [NSString stringWithFormat:@"%u小时前", (int)(interval / 60 / 60)];
        } else if (interval < (2 * 24 * 60 * 60)) { // 昨天
            [formatter setDateFormat:@"昨天"];
            return [formatter stringFromDate:date];
        } else if (interval < (3 * 24 * 60 * 60)) { // 前天
            [formatter setDateFormat:@"前天"];
            return [formatter stringFromDate:date];
        } else {
            [formatter setDateFormat:@"yyyy"];
            NSString * yearStr = [formatter stringFromDate:date];
            NSString *nowYear = [formatter stringFromDate:[NSDate date]];
            
            if ([yearStr isEqualToString:nowYear]) {  //在同一年
                [formatter setDateFormat:@"MM月dd日"];
                return [formatter stringFromDate:date];
            } else {   //不同年
                [formatter setDateFormat:@"yyyy年MM月dd日"];
                return [formatter stringFromDate:date];
            }
        }
    }
    @catch (NSException *exception) {
        return @"";
    }
    @finally {
    }
}

+ (NSTimeInterval )timeSinceNowNSTimeInterval:(NSDate *)date {
    @try {
        NSTimeInterval interval = 0 - [date timeIntervalSinceNow];
        return interval;
    }
    @catch (NSException *exception) {
        return 0;
    }
    @finally {
    }
}

/**
 *	@brief	把秒转化为时间字符串显示，播放器常用
 *
 *	@param 	durartion 	传入参数
 *
 *	@return	播放器播放进度时间，比如
 */
+ (NSString *)changeSecondsToString:(CGFloat)durartion {
    int hh = durartion/(60 * 60);
    int mm = hh > 0 ? (durartion - 60*60)/60 : durartion/60;
    int ss = (int)durartion%60;
    NSString *hhStr,*mmStr,*ssStr;
    if (hh == 0) {
        hhStr = @"00";
    } else if (hh > 0 && hh < 10) {
        hhStr = [NSString stringWithFormat:@"0%d",hh];
    } else {
        hhStr = [NSString stringWithFormat:@"%d",hh];
    }
    if (mm == 0) {
        mmStr = @"00";
    } else if (mm > 0 && mm < 10) {
        mmStr = [NSString stringWithFormat:@"0%d",mm];
    } else {
        mmStr = [NSString stringWithFormat:@"%d",mm];
    }
    if (ss == 0) {
        ssStr = @"00";
    } else if (ss > 0 && ss < 10) {
        ssStr = [NSString stringWithFormat:@"0%d",ss];
    } else {
        ssStr = [NSString stringWithFormat:@"%d",ss];
    }
    if ([hhStr isEqualToString:@"00"]) {
        return [NSString stringWithFormat:@"%@:%@",mmStr,ssStr];
    } else {
        return [NSString stringWithFormat:@"%@:%@:%@",hhStr,mmStr,ssStr];
    }
}

/**
 *  @brief  格式化数值
 *
 *  @param  value数值
 *  
 *  @return 返回格式字符串
 */
+ (NSString *)encodeNumber:(int)value {
    @try {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:value]];
        return string;
    } @catch (NSException *exception) {
        return @"";
    } @finally {
    }
}

/**
 *	@brief	UILabel高度
 *
 *	@param 	str 	文字
 *	@param 	front 	字体
 *	@param 	frontwidth 	UILabel宽度
 *
 *	@return	返回高度
 */
+ (CGFloat)returnHeightFloat:(NSString *)str frontSize:(UIFont*)front frontWidth:(CGFloat)frontwidth {
    CGSize asize = CGSizeMake(frontwidth,5000);
    NSDictionary *attribute = @{NSFontAttributeName:front};
    CGSize labelsize = [str boundingRectWithSize:asize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return  labelsize.height;
}

/*!
 @brief label长度
 @param string 输入文字
 @param frontSize 字体大小
 @param maxSize 最大长度限制
 @return label长度
 */
+(CGFloat)returnWidthWithLabel:(NSString *)string frontSize:(CGFloat )frontSize maxSize:(CGSize)maxSize {
    NSDictionary* attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:frontSize]};
    CGSize labSize = [string boundingRectWithSize: maxSize
                                          options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                       attributes:attributes
                                          context:nil].size;
    
    return labSize.width;
}

+(CGFloat)returnWidthWithLabelText:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary* attributes = @{NSFontAttributeName:font};
    CGSize labSize = [string boundingRectWithSize: maxSize
                                          options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                       attributes:attributes
                                          context:nil].size;
    
    return labSize.width;
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

/**
 * @brief 图片压缩
 *  UIGraphicsGetImageFromCurrentImageContext函数完成图片存储大小的压缩
 * Detailed
 * @param[in] 源图片；指定的压缩size
 * @param[out] N/A
 * @return 压缩后的图片
 * @note
 */
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();  // End the context
    return newImage;
}

+ (void)shakeAnimationForView:(UIView *)shakeView {//view晃动动画
    CALayer *viewLayer = shakeView.layer;  // 获取到当前的View
    CGPoint position = viewLayer.position;  // 获取当前View的位置
    // 移动的两个终点位置
    CGPoint x = CGPointMake(position.x + 15, position.y);
    CGPoint y = CGPointMake(position.x - 15, position.y);
    // 设置动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];// 设置运动形式
    [animation setFromValue:[NSValue valueWithCGPoint:x]];// 设置开始位置
    [animation setToValue:[NSValue valueWithCGPoint:y]];// 设置结束位置
    [animation setAutoreverses:YES];// 设置自动反转
    [animation setDuration:0.1]; // 设置时间
    [animation setRepeatCount:3];// 设置次数
    [viewLayer addAnimation:animation forKey:nil];// 添加上动画
}

+ (BOOL) validateEmail:(NSString *)email {//校验邮件格式
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL) validatePassword:(NSString *)passWord {//校验密码6-16位数字或字母组合
    NSString *regex = @"^[0-9A-Za-z]{6,16}$";
    NSPredicate *   pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:passWord];
}

+ (BOOL)validatePhoneNum:(NSString *)phoneNum {//校验电话号码
    NSString *regex = @"^1[3|4|5|6|7|8|9][0-9]\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phoneNum];
}

+ (void)deleteSingleNotificationWithRemarkId:(NSInteger)remarkId {
    NSArray *notArray = [[UIApplication sharedApplication] scheduledLocalNotifications];
    for (UILocalNotification *notification in notArray) {
        if ([[notification.userInfo objectForKey:@"remarkId"] integerValue] == remarkId) {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

+ (NSUInteger) lenghtWithString:(NSString *)string {//计算文本长度
    NSUInteger len = string.length;
    NSString * pattern  = @"[\u4e00-\u9fa5]";// 汉字字符集
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    // 计算中文字符的个数
    NSInteger numMatch = [regex numberOfMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, len)];
    return len + numMatch;
}

+ (UIImage *)fixOrientation:(UIImage *)aImage { //设置图片方向
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (UIImage *)cropImageWithRect:(CGRect)newImageSize image:(UIImage *)image {//裁切图片
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, newImageSize);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}

+ (UIImage *)changeViewToImage:(UIView *)currentView compress:(CGFloat)compress {
    UIGraphicsBeginImageContextWithOptions(currentView.bounds.size, NO, compress);
    if ([currentView respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [currentView drawViewHierarchyInRect:currentView.bounds afterScreenUpdates:NO];
    } else {
        [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (compress < 1) {
        viewImage = [self imageWithImage:viewImage scaledToSize:CGSizeMake(viewImage.size.width * compress, viewImage.size.height * compress)];
    }
    return viewImage;
}

+ (BOOL)imageIsHasAlphaWithImage:(UIImage *)image {
    int alpha = CGImageGetAlphaInfo(image.CGImage);
    BOOL hasAlpha = !(alpha == kCGImageAlphaNone ||
                      alpha == kCGImageAlphaNoneSkipFirst ||
                      alpha == kCGImageAlphaNoneSkipLast);
    return hasAlpha;
}

//完全复制一项
+ (id)totalCopyOneItem:(id)oldItem {
    if (oldItem != nil) {
        NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:oldItem];
        id newElementArray = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
        return newElementArray;
    } else {
        return nil;
    }
}

+ (void)copyStringWithString:(NSString *)needCopyStr {//复制字符串
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (needCopyStr && [needCopyStr isKindOfClass:[NSString class]] && needCopyStr.length > 0) {
        [pasteboard setString:needCopyStr];
    }
}

+ (UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size {/** 自定义的字体 */
    if (!path) {
        NSLog(@"字体路径无效");
        return nil;
    }
    NSURL *fontUrl = [NSURL fileURLWithPath:path];
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
    [UIFont familyNames];
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerUnregisterGraphicsFont(fontRef,nil);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

+ (id)getUserPreferenceObjectForKey:(NSString *)key {
    NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    if ([userId isKindOfClass:[NSString class]] && userId.length > 0) {
        NSString *keyWithUid = [key stringByAppendingString:userId];
        return [[NSUserDefaults standardUserDefaults] objectForKey:keyWithUid];
    }
    return nil;
}

+ (void)saveUserPreferenceObject:(NSObject *)object forKey:(NSString *)key {
    NSString *keyWithUid = [key stringByAppendingString:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]];
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    [preference setObject:object forKey:keyWithUid];
    [preference synchronize];
}

//根据账号type返回name
+ (NSString *)getUserTypeStrWithUserType:(NSInteger)userType {
    NSString *userTypeStr = nil;
    switch (userType) {
        case kOrdinaryAccount:
            userTypeStr = @"普通账号";
            break;
        case kCorporateAccount:
            userTypeStr = @"企业账号";
            break;
        case kEnterpriseSubAccount:
            userTypeStr = @"企业子账号";
            break;
        case kXiuTuiSubAccount:
            userTypeStr = @"秀推子账号";
            break;
        case kSuperAccount:
            userTypeStr = @"高级账户";
            break;
        case kServiceAccount:
            userTypeStr = @"服务账号";
            break;
        case kPublicAccount:
            userTypeStr = @"公共账号";
            break;
        case kPublicSubAccount:
            userTypeStr = @"公共子账号";
            break;
        case kOperationAndMaintenanceAccount:
            userTypeStr = @"运维账号";
            break;
        case kDefaultUserType:
            userTypeStr = @"";
            break;
        default:
            userTypeStr = @"账号类型";
            break;
    }
    return userTypeStr;
}

+ (NSString *)getBundleVersion {//获取系统版本号
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *versionNum = [infoDict objectForKey:@"CFBundleShortVersionString"];
    return versionNum;
}

#pragma mark 获取网络状态
+ (NSString *)getNetWorkStates {//获取网络状态，根据状态栏获取网络状态
    NSString *state = [[NSString alloc]init];
    UIApplication *app = [UIApplication sharedApplication];
    BOOL canUseStatus = NO;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 13.0 && [[app valueForKeyPath:@"statusBar"] isKindOfClass:NSClassFromString(@"UIStatusBar")]) {
        canUseStatus = YES;
    }
    
    if (!canUseStatus) {
        switch ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus) {
            case AFNetworkReachabilityStatusUnknown:
                state = @"未知网络";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                state = @"无网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                state = @"移动网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                state = @"wifi";
                break;
            default:
                state = @"未知网络";
                break;
        }
    } else {
        UIApplication *app = [UIApplication sharedApplication];
        NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
        int netType = 0;
        //获取到网络返回码
        for (id child in children) {
            if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
                //获取到状态栏
                netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
                
                switch (netType) {
                    case 0:
                        state = @"无网络"; //无网模式
                        break;
                    case 1:
                        state =  @"2G";
                        break;
                    case 2:
                        state =  @"3G";
                        break;
                    case 3:
                        state =   @"4G";
                        break;
                    case 5:
                        state =  @"wifi";
                        break;
                    default:
                        break;
                }
            }
            //根据状态选择
        }
    }
    return state;
}

#pragma mark 转json串
+ (NSString *)stringChangeWithDataWithJSONObject:(id)obj {
    if (obj) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:nil];
        if (data) {
            NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
            return jsonStr;
        }
    }
    return nil;
}

+ (NSString *)valueUrlstringForJudgeHttp:(NSString *)urlStr {
    NSString *paseredUrl = @"";
    if ([urlStr isKindOfClass:[NSString class]] && urlStr.length > 0) {
        if ([urlStr hasPrefix:@"http"]) {
            paseredUrl = urlStr;
        } else if ([urlStr hasPrefix:@"/tencent"]) { //腾讯云图片地址
            paseredUrl = [NSString stringWithFormat:@"%@%@",kTencentimgcdn,urlStr];
        } else if ([urlStr hasPrefix:@"//"]) {
            paseredUrl = [NSString stringWithFormat:@"https:%@",urlStr];
        } else {
            paseredUrl = [NSString stringWithFormat:@"%@%@",kImageHeaderUrl,urlStr];
        }
    }
    return paseredUrl;
}

+ (NSString *)videoValueUrlstringForJudgeHttp:(NSString *)urlStr {
    NSString *paseredUrl = @"";
    if ([urlStr isKindOfClass:[NSString class]] && urlStr.length > 0) {
        if ([urlStr hasPrefix:@"http"]) {
            paseredUrl = urlStr;
        } else if ([urlStr hasPrefix:@"/tencent"]) { //腾讯云视频地址
            paseredUrl = [NSString stringWithFormat:@"%@%@",kTencentcdn,urlStr];
        } else if ([urlStr hasPrefix:@"//"]) {
            paseredUrl = [NSString stringWithFormat:@"https:%@",urlStr];
        } else {
            paseredUrl = [NSString stringWithFormat:@"%@%@",kVideoFileHeaderUrl,urlStr];
        }
    }
    return paseredUrl;
}

+ (BOOL)pushSwitchOff {
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone) {
        return YES;
    }else{
        return NO;
    }
}

+ (CAGradientLayer *)getGradientLayerWithColors:(NSArray *)colors withSize:(CGSize)GradientSize{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    NSMutableArray *gradientColors = [[NSMutableArray alloc]init];
    for (NSString *colorStr in colors) {
        [gradientColors addObject:(__bridge id)[CommUtls changeToColorWithHexAndRgbString:colorStr].CGColor];
    }
    gradientLayer.colors = gradientColors;
    gradientLayer.locations = @[@0.0f, @1.0f];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, GradientSize.width, GradientSize.height);
    return gradientLayer;
}

+ (CAGradientLayer *)getGradientLayerWithColors:(NSArray *)colors
                                       withSize:(CGSize)GradientSize
                                  withDirection:(BOOL)isHorizontal{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    NSMutableArray *gradientColors = [[NSMutableArray alloc]init];
    for (NSString *colorStr in colors) {
        [gradientColors addObject:(__bridge id)[CommUtls changeToColorWithHexAndRgbString:colorStr].CGColor];
    }
    gradientLayer.colors = gradientColors;
    if (colors.count == 3) {
        gradientLayer.locations = @[@0.0f, @0.5, @1.0f];
    }else{
        gradientLayer.locations = @[@0.0f, @1.0f];
    }
    if (isHorizontal) {
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
    }else{
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1.0);
    }
    gradientLayer.frame = CGRectMake(0, 0, GradientSize.width, GradientSize.height);
    return gradientLayer;
}

+ (NSString*)deviceModelName {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    //iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone6Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone6sPlus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone5SE";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone7(CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone7(GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone7Plus(CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone7Plus(GSM)";
    
    //iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([deviceModel isEqualToString:@"iPad4,4"]
        ||[deviceModel isEqualToString:@"iPad4,5"]
        ||[deviceModel isEqualToString:@"iPad4,6"])      return @"iPad mini 2";
    
    if ([deviceModel isEqualToString:@"iPad4,7"]
        ||[deviceModel isEqualToString:@"iPad4,8"]
        ||[deviceModel isEqualToString:@"iPad4,9"])      return @"iPad mini 3";
    return deviceModel;
}

+ (NSDateComponents *)getTwoDateInterval {
    NSString *joinTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"joinTime"];
    NSDate *joinTimeDate = [NSDate dateWithTimeIntervalSince1970:([joinTime longLongValue] / 1000)];
    NSString *expiryTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"expiryTime"];
    NSDate *expiryTimeDate = [NSDate dateWithTimeIntervalSince1970:([expiryTime longLongValue] / 1000)];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date1 = [formatter dateFromString:[formatter stringFromDate:joinTimeDate]];
    NSDate *date2 = [formatter dateFromString:[formatter stringFromDate:expiryTimeDate]];
    // 2.创建日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 3.利用日历对象比较两个时间的差值
    NSDateComponents *cmps = [calendar components:type fromDate:date1 toDate:date2 options:0];
    return cmps;
}

//绘制渐变色
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr {
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(__bridge id)[self changeToColorWithHexAndRgbString:fromHexColorStr].CGColor,(__bridge id)[self changeToColorWithHexAndRgbString:toHexColorStr].CGColor];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0.3,@1];
    return gradientLayer;
}

//label行高、字间距
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
}

#pragma mark 颜色处理
+ (UIColor *)changeToColorWithHexAndRgbString:(NSString *)stringToConvert {
    if ([stringToConvert isKindOfClass:[UIColor class]]) {
        return (UIColor *)stringToConvert;
    }
    if (![stringToConvert isKindOfClass:[NSString class]]) {
        return [UIColor clearColor];
    }
    
    UIColor *deColor = nil;
    if ([stringToConvert hasPrefix:@"#"] || [stringToConvert hasPrefix:@"0X"] || stringToConvert.length == 6) { //是16进制的颜色值
        if (stringToConvert.length == 4) { //比如 #fff
            unichar lastChar = [stringToConvert characterAtIndex:3];
            stringToConvert = [NSString stringWithFormat:@"%@%c%c%c",stringToConvert,lastChar,lastChar,lastChar];
        }
        NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        if ([cString hasPrefix:@"0X"]) {
            cString = [cString substringFromIndex:2];
        } else if ([cString hasPrefix:@"#"]) {
            cString = [cString substringFromIndex:1];
        }
    
        if (cString.length == 6) {
            NSRange range;
            range.location = 0;
            range.length = 2;
            NSString *rString = [cString substringWithRange:range];
            
            range.location = 2;
            NSString *gString = [cString substringWithRange:range];
            
            range.location = 4;
            NSString *bString = [cString substringWithRange:range];
            
            // Scan values
            unsigned int r, g, b;
            [[NSScanner scannerWithString:rString] scanHexInt:&r];
            [[NSScanner scannerWithString:gString] scanHexInt:&g];
            [[NSScanner scannerWithString:bString] scanHexInt:&b];
            if ([[UIDevice currentDevice] systemVersion].floatValue >= 10.0f) {
                deColor = [UIColor colorWithDisplayP3Red:((float) r / 255.0f)
                                                green:((float) g / 255.0f)
                                                 blue:((float) b / 255.0f)
                                                alpha:1.0f];
            }else{
                deColor = [UIColor colorWithRed:((float) r / 255.0f)
                                       green:((float) g / 255.0f)
                                        blue:((float) b / 255.0f)
                                       alpha:1.0f];
            }
        }
    } else {
        NSRange range1 = [stringToConvert rangeOfString:@"("];
        NSRange range2 = [stringToConvert rangeOfString:@")"];
        if (range2.location > range1.location + 1 && [stringToConvert length] > range2.location - range1.location - 1) {
            NSString *string = [stringToConvert substringWithRange:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
            NSArray *colorArray = [string componentsSeparatedByString:@","];
            if ([colorArray count] >= 3) {
                CGFloat redValue = 255.0;
                CGFloat greenValue = 255.0;
                CGFloat blueValue = 255.0;
                CGFloat alphaValue = 1.0;

                if ([[colorArray objectAtIndex:0] respondsToSelector:@selector(floatValue)]) {
                    redValue = [[colorArray objectAtIndex:0] floatValue];
                }
                if ([[colorArray objectAtIndex:1] respondsToSelector:@selector(floatValue)]) {
                    greenValue = [[colorArray objectAtIndex:1] floatValue];
                }
                if ([[colorArray objectAtIndex:2] respondsToSelector:@selector(floatValue)]) {
                    blueValue = [[colorArray objectAtIndex:2] floatValue];
                }
                if (colorArray.count > 3) {
                    if ([[colorArray objectAtIndex:3] respondsToSelector:@selector(floatValue)]) {
                        alphaValue = [[colorArray objectAtIndex:3] floatValue];
                    }
                }
                deColor = [UIColor colorWithRed:((float) redValue / 255.0f)
                                          green:((float) greenValue / 255.0f)
                                           blue:((float) blueValue / 255.0f)
                                          alpha:alphaValue];
            }
        }
    }
    if (deColor) {
        return deColor;
    } else {
        return [UIColor clearColor];
    }
}

//rgb颜色转十六进制
+ (NSString *)resetRgbColorToHexStringColor:(NSString *)valueStr {
    if (![valueStr isKindOfClass:[NSNull class]] && valueStr != nil) {
        if ([valueStr rangeOfString:@"#"].location != NSNotFound) {
            return valueStr;
        } else {
            NSRange range1 = [valueStr rangeOfString:@"("];
            NSRange range2 = [valueStr rangeOfString:@")"];
            if (range2.location > range1.location + 1 && [valueStr length] > range2.location - range1.location - 1) {
                NSString *string = [valueStr substringWithRange:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
                NSArray *colorArray = [string componentsSeparatedByString:@","];
                if ([colorArray count] >= 3) {
                    NSString *color1 = [colorArray objectAtIndex:0];
                    if ([color1 integerValue] < 16) {
                        color1 = [NSString stringWithFormat:@"0%lx",(long)[color1 integerValue]];
                    } else {
                        color1 = [NSString stringWithFormat:@"%lx",(long)[color1 integerValue]];
                    }
                    
                    NSString *color2 = [colorArray objectAtIndex:1];
                    if ([color2 integerValue] < 16) {
                        color2 = [NSString stringWithFormat:@"0%lx",(long)[color2 integerValue]];
                    } else {
                        color2 = [NSString stringWithFormat:@"%lx",(long)[color2 integerValue]];
                    }
                    
                    NSString *color3 = [colorArray objectAtIndex:2];
                    if ([color3 integerValue] < 16) {
                        color3 = [NSString stringWithFormat:@"0%lx",(long)[color3 integerValue]];
                    } else {
                        color3 = [NSString stringWithFormat:@"%lx",(long)[color3 integerValue]];
                    }
                    
                    NSString *str = [[NSString alloc] initWithFormat:@"#%@%@%@",color1,color2,color3];
                    return str;
                }
            }
        }
    }
    return @"#ffffff";
}

+ (UIColor *)changeToColorWithHexAndRgbString:(NSString *)stringToConvert withAlpha:(CGFloat)alpha {
    UIColor *color = [self changeToColorWithHexAndRgbString:stringToConvert];
    if (alpha == 1) {
        return color;
    } else {
        return [color colorWithAlphaComponent:alpha];
    }
}

//UIColor转成16进制颜色值
+ (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

//Ua
+ (NSString *)getUserAgent{
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    return userAgent;
}

//16进制颜色转成rgba
+ (NSString *)getRGBAcolorWithHexString: (NSString *)color colorAlpha:(CGFloat)alpha{
    if ([color isKindOfClass:[NSString class]] && color.length > 0) {
        NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
        
        // String should be 6 or 8 characters
        if ([cString length] < 6) {
            return @"rgba(0, 0, 0, 0)";
        }
        // 判断前缀
        if ([cString hasPrefix:@"0X"])
            cString = [cString substringFromIndex:2];
        if ([cString hasPrefix:@"#"])
            cString = [cString substringFromIndex:1];
        if ([cString length] != 6)
            return @"rgba(0, 0, 0, 0)";
        // 从六位数值中找到RGB对应的位数并转换
        NSRange range;
        range.location = 0;
        range.length = 2;
        //R、G、B
        NSString *rString = [cString substringWithRange:range];
        range.location = 2;
        NSString *gString = [cString substringWithRange:range];
        range.location = 4;
        NSString *bString = [cString substringWithRange:range];
        // Scan values
        unsigned int r, g, b;
        [[NSScanner scannerWithString:rString] scanHexInt:&r];
        [[NSScanner scannerWithString:gString] scanHexInt:&g];
        [[NSScanner scannerWithString:bString] scanHexInt:&b];
        
        return [NSString stringWithFormat:@"rgba(%u,%u,%u,%f)", r, g, b, alpha];
    } else {
        return @"";
    }
}

+ (NSString *)isBlankString:(id)obj {
    if (obj&&[obj isKindOfClass:[NSString class]]) {
        return obj;
    } else {
        return @"";
    }
}

+ (NSString *)splicingPlatformForUrl:(NSString *)url{
    NSString *backUrl = @"";
     if ([url rangeOfString:@"platform"].location == NSNotFound ) {
         if ([url rangeOfString:@"#"].location == NSNotFound) {
             if ([url rangeOfString:@"?"].location == NSNotFound) {
                 url = [NSString stringWithFormat:@"%@?platform=1",url];
             }else{
                 url = [NSString stringWithFormat:@"%@&platform=1",url];
             }
         }else{
             NSArray *array = [url componentsSeparatedByString:@"#"];
             NSString *fist = [array firstObject];
             NSArray *last = [array lastObject];
             if ([fist rangeOfString:@"?"].location == NSNotFound) {
                 fist = [NSString stringWithFormat:@"%@?platform=1",fist];
             }else{
                 fist = [NSString stringWithFormat:@"%@&platform=1",fist];
             }
             url = [NSString stringWithFormat:@"%@#%@",fist,last];
         }
         
     }else{
         if ([url rangeOfString:@"platform=2"].location != NSNotFound) {
             url = [url stringByReplacingOccurrencesOfString:@"platform=2" withString:@"platform=1"];
         }
     }
    backUrl = [url stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return backUrl;
}

+ (NSString *)convertDataToHexStr:(NSData *)data {
    if (!data || [data length] == 0) {
        return @"";
        
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
                
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
        
    }];
    return string;
    
}
@end
NS_ASSUME_NONNULL_END
