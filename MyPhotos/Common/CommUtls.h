//
//  CommUtls.h
//  UtlBox
//
//  Created by cdel cyx on 12-7-10.
//  Copyright (c) 2012年 cdeledu. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UserType) {
    /**用户未登录/未获取到用类型*/
    kDefaultUserType = 0,
    /** 普通账号 */
    kOrdinaryAccount = 1,
    /** 企业账号 */
    kCorporateAccount = 2,
    /** 企业子账号 */
    kEnterpriseSubAccount = 21,
    /** 秀推子账号 */
    kXiuTuiSubAccount = 22,
    /** 高级账户 */
    kSuperAccount = 3,
    /** 服务账号 */
    kServiceAccount = 4,
    /** 公共账号 */
    kPublicAccount = 5,
    /** 公共子账号 */
    kPublicSubAccount = 51,
    /** 运维账号 */
    kOperationAndMaintenanceAccount = 99,
};

typedef NS_ENUM(NSInteger, CompanyMemberType) {
    ///体验版会员
    MemberTypeTiYan = 1,
    ///高级版会员
    MemberTypeGaoJi = 2,
    ///畅想版会员
    MemberTypeChangXiang = 4,
    ///专业版会员
    MemberTypeZhuanYe = 3,
    ///渠道专项版服务
    MemberTypeQuDao = 5,
    ///企业体验版
    MemberTypeQiYeTiYan = 6,
    ///企业基础版
    MemberTypeQiYeJiChu = 7,
    ///企业标准版
    MemberTypeQiYeBiaoZhun = 8,
    ///企业高级版
    MemberTypeQiYeGaoJi = 9
};

typedef NS_ENUM(NSInteger, DeviceType) {
    App = 1,//app端作品
    PC = 2, //电脑端作品
    APP_PC = 5   //app、pc、小程序
};


///H5快捷创建类型
typedef enum : NSUInteger {
    ///字说字画
    kCreatePhoneticTranH5SceneType,
    ///祝福贺卡
    kCreateGreetingCardsH5SceneType,
    ///音乐相册
    kCreateMusicPhotoH5SceneType,
} QuickCreateH5SceneType;

///海报快捷创建类型
typedef enum : NSUInteger {
    ///拼图
    kCreatePinTuLDSceneType,
    ///艺术二维码
    kCreateArtQRCodeLDSceneType,
    ///九宫格
    kCreateNineSquareLDSceneType,
    ///批量水印
    kCreateBatchWatermarkLDSceneType

} QuickCreateLightDesignSceneType;

///视频快捷创建类型
typedef enum : NSUInteger {
    ///实拍视频
    kCreateTemplateShotVideoSceneType,
    ///快闪
    kCreateFlashVideoSceneType,
    ///视频相册
    kCreateAlbumVideoSceneType,
    ///卡点
    kCreateCardPointVideoSceneType,
    ///添加字幕
    kCreateAddSubTitleSceneType

} QuickCreateVideoSceneType;

///长页快捷创建类型
typedef enum :NSUInteger{
    ///空白创建
    kCreateEmptySceneType,
    
}QuickCreateLongPageSceneType;
@interface CommUtls : NSObject<CAAnimationDelegate>

//创建文件
+ (void)makeDirs:(NSString *)dir;

/** 数字显示格式 */
+ (NSString *)encodeNumber:(int)value;

+ (NSTimeInterval )timeSinceNowNSTimeInterval:(NSDate *)date;
+ (NSString *)timeSinceNowWithDateStr:(NSDate *)date;

//把秒转化为时间字符串显示，播放器常用
+ (NSString *)changeSecondsToString:(CGFloat)durartion;

//返回UILabel高度
+ (CGFloat)returnHeightFloat:(NSString *)str frontSize:(UIFont*)front frontWidth:(CGFloat)frontwidth;

//返回label长度
+(CGFloat)returnWidthWithLabel:(NSString *)string frontSize:(CGFloat )frontSize maxSize:(CGSize)maxSize;

+(CGFloat)returnWidthWithLabelText:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize;

//图片压缩
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

//图片方向
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//图片裁剪
+ (UIImage *)cropImageWithRect:(CGRect)newImageSize image:(UIImage *)image;

//把当前view生成图片 并压缩  compress 压缩倍数 0~1
+ (UIImage *)changeViewToImage:(UIView *)currentView compress:(CGFloat)compress;

//判断图片是否有透明底
+ (BOOL)imageIsHasAlphaWithImage:(UIImage *)image;

//增加icloud不被备份
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

//抖动
+ (void)shakeAnimationForView:(UIView *)shakeView;

//邮箱合法验证
+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)validatePassword:(NSString *)passWord;
//电话合法验证
+ (BOOL)validatePhoneNum:(NSString *)phoneNum;

+ (void)deleteSingleNotificationWithRemarkId:(NSInteger)remarkId;

//判断长度 这里把2位字符转出1位来计算
+ (NSUInteger) lenghtWithString:(NSString *)string;

//拷贝字符串至剪切板
+ (void)copyStringWithString:(NSString *)needCopyStr;

//获取随机色
+ (UIColor *)randomColorForImageBack;

/** 自定义的字体 */
+ (UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size;

+ (id)getUserPreferenceObjectForKey:(NSString *)key;

+ (void)saveUserPreferenceObject:(NSObject *)object forKey:(NSString *)key;

/** 获取作品是否包含广告 */
+ (NSInteger)getEqAdTypeWithSceneInfo:(NSString *)propertyStr ;
+ (NSString *)getUserTypeStrWithUserType:(NSInteger)userType;

//获取版本号
+ (NSString *)getBundleVersion;

//获取网络状态，根据状态栏获取网络状态
+ (NSString *)getNetWorkStates;

// 转json串
+ (NSString *)stringChangeWithDataWithJSONObject:(id)obj;

/** 判断推送开关是否关闭 */
+ (BOOL)pushSwitchOff;
/** 添加渐变 */
+ (CAGradientLayer *)getGradientLayerWithColors:(NSArray *)colors withSize:(CGSize)GradientSize;
/** 获取渐变层：最多支持三种颜色 */
+ (CAGradientLayer *)getGradientLayerWithColors:(NSArray *)colors
                                       withSize:(CGSize)GradientSize
                                  withDirection:(BOOL)isHorizontal;
+ (NSString*)deviceModelName;
+ (NSDateComponents *)getTwoDateInterval;
//绘制渐变色
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
///label行高、字间距
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;
+(BOOL)getUserIfIsBinded;
/** 获取用户是否关联手机号 */
+(BOOL)getUserIfIsRelatedPhone;
#pragma mark 颜色色值

//UIColor转成16进制颜色值
+ (NSString *)hexStringFromColor:(UIColor *)color;

//rgb颜色更改为16进制
+ (NSString *)resetRgbColorToHexStringColor:(NSString *)valueStr;


//Ua
+ (NSString *)getUserAgent;

//16进制颜色转成rgba
+ (NSString *)getRGBAcolorWithHexString: (NSString *)color colorAlpha:(CGFloat)alpha;


#pragma mark 通用方法
/*
 该方法支持将图片地址补全 重要：已包含了特殊字符转义，使用该方法时无需再进行转义
 支持四种格式：
 1、以 http 开头，直接返回
 2、以 //:res 返回，补齐https
 3、以 /tencent/开头，补齐腾讯头文件
 4、补充七牛头文件
*/
+ (NSString *)valueUrlstringForJudgeHttp:(NSString *)urlStr ;

/** 视频链接拼接 */
+ (NSString *)videoValueUrlstringForJudgeHttp:(NSString *)urlStr;

/*
 支持以下格式转换成UIColor,失败时返回[UIColor clearColor]
 rgb   rgba   #ffffff    #ffff  ffffff
 */
+ (UIColor *)changeToColorWithHexAndRgbString:(NSString *)stringToConvert;
//支持上述方法所有类型，且添加透明度
+ (UIColor *)changeToColorWithHexAndRgbString:(NSString *)stringToConvert withAlpha:(CGFloat)alpha;

//完全拷贝  包括指针地址和内容
+ (id)totalCopyOneItem:(id)oldItem;

//映射 将字典类型的内容，映射给NSObject ，包括NSObject的继承父类
+ (NSObject *)initPropertyWithClass:(NSObject *)infoObject fromDic:(NSDictionary *)jsonDic;

//映射 将NSObject内容，映射给另外一个NSObject 包括NSObject的继承父类
+ (void)initPropertyWithClass:(NSObject *)infoObject fromClass:(NSObject *)sourceObject;

// 空字符串判断
+ (NSString *)isBlankString:(id)obj;
/// url拼接platform
/// @param url 需要拼接platform的url
+ (NSString *)splicingPlatformForUrl:(NSString *)url;

@end
