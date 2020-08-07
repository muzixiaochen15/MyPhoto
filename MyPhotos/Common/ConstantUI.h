//
//  ConstantUI.h
//  YiQiXiu
//
//  Created by Sherry on 14-10-14.
//  Copyright (c) 2014年 Sherry. All rights reserved.
//

#ifndef YiQiXiu_ConstantUI_h
#define YiQiXiu_ConstantUI_h

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define IsIOS8 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
#define IsIOS9 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 9.0)
#define IsIOS10 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 10.0)
#define isIOS13 ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 13.0)
#define KScreenSize [[UIScreen mainScreen] bounds].size

#define WIDTH_OF_SCREEN [[UIScreen mainScreen] bounds].size.width
#define HEIGHT_OF_SCREEN [[UIScreen mainScreen] bounds].size.height
#define SCREEN_MAX_LENGTH (MAX(WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN))
#define SCREEN_MIN_LENGTH (MIN(WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (((WIDTH_OF_SCREEN == 375) && (SCREEN_MAX_LENGTH == 812.0)) || (SCREEN_MAX_LENGTH >= 812.0))//补充SCREEN_MAX_LENGTH > 812.0，适配xs max、xr
#define RGBA(r, g, b, a) ([UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:a])

#define TOPBAR_HEIGHT 0


#define NAVIGATIONBAR_HEIGHT (IS_IPHONE_X ? 89 : 65)
#define TABBAR_HEIGHT (IS_IPHONE_X ? 83 : 49)
#define STATUS_BAR_HEIGHT (IS_IPHONE_X ? 44 : 20)
#define IPHONE_X_TABBAR_SPACE  (IS_IPHONE_X ? 34 : 0)    //底部空隙

typedef NS_ENUM(NSInteger, ScreenSize) {
    Iphone4s = 960,
    Iphone5s = 1136,
    Iphone6 = 1334,
    Iphone6Plus = 1472,
    IphoneX = 1624
};

#pragma mark 再改、增加、删除toolsType的时候注意一下，不要改了原本的顺序，这个是全局都在用！！！！！！！！！！！如果改了，请在所有使用的地方验证！！！！！！！
typedef NS_ENUM(NSInteger, CreativeToolsType) {
    ///全部
    AllToolsType = -1,
    ///H5
    H5ToolsType,
    ///海报
    LightDesignToolsType,
    ///长页
    LongPageToolsType,
    ///易表单
    EasyFormToolsType,
    ///视频
    VideoToolsType
};

typedef enum : NSUInteger {
    kClickTypeWatchScene,
    kClickTypeSpread,
    kClickTypeForm,
    kClickTypeShare,
    kClickTypeManage,
    kClickTypeCreateScene,
    kClickTypeDownload,
    kClickTypeEdit
} SceneListViewClickType;

enum {
    kNeedPublish = 0, //未发布初次创建
    kNeedPubishEdit,  //未发布已修改
    kPublished        //已发布
} PublishState;

enum{
    kJustOpenUrl            = 0,
    kCreateUseSample        = 1,   //这里先进预览，在点击使用
    
    kCreateUseTemplet       = 2,
    kCreateUseAlbum         = 3,
    
    kCreateUseCard          = 4,
    kShowAlbumList          = 5,
    kShowCardList           = 6,
    kShowSampleList         = 7,
    kShowTempletList        = 9,
    kShowTopicList          = 10,
    kShowTopicDetail        = 11,
    kShowPaySample          = 12,    //付费模板(原名样例)
    kShowPayTemplte         = 13,    //付费模板
    kRechargeWeb            = 14,    //web页面充值
    kReceiveCoupon          = 15,    //优惠券领取
    kWebShowInteraction     = 16,     //周年庆web页、js交互等
    kShowSaveImageTip       = 17,   //保存图片
    kShowChannelView        = 18,        //频道分类页
    kShowImageOnly          = 19,        //只显示图片，不做任何跳转
    kShowLuckDrawWeb        = 20,        //web抽奖、翻牌子
    kShowRechargeVc         = 21,        //跳转充值界面
    kLeaderboards           = 22,       //top排行榜
    kShowNewCardList        = 23,       //新的贺卡列表
    kShowNewAlbumList       = 24,       //新的音乐相册列表
    kShowRemoveShadowe      = 25,       //去广告
    kShowSceneGuarantee     = 26,       //作品保障
    kShowSceneAudit         = 27,        //作品审核
    kShowPictureCategory    = 28,       //图片库的banner跳转其他分类
    kShowMusicCategory      = 29,       //音乐库的banner跳转其他分类
    kShowFontCategory       = 30,       //字体库的banner跳转其他分类
    kShowMemberCenter       = 31,       //会员中心
    kShowMemberPay          = 32,       //会员支付
    kShowMemberAreaList     = 33,       //会员专区（会员样例列表）
    kShowAppStartPopBox     = 34,       //启动页弹窗（送作品的弹窗）
    kShowAndCreateDaySign   = 35,       //显示日签
    kShowInvitingFriend     = 36,       //老带新活动、邀请好友
    kFriendsGetTemplet      = 37,       //好友助力得模板
    kShowCardDetial         = 38,       //新的k贺卡创建页面
    kSkipToWXMiniProgram    = 39,       //跳转到微信小程序
    kShowVideoList          = 40,       //跳未接商城之前的视频列表页面
    kShowCompanyMemnberList = 41,       //跳转企业会员升级页面
    kShowLDEmptyCreateList  = 42,       //跳转海报空白创建页面
    kShowMyLevel            = 43,       //跳转我的等级页面-4.7.0切换为新的积分wap页
    kShowTaskCenter         = 44,       //跳转任务中心页面
    kShowAutoMemberCenter   = 45,       //4.4.0版本后的会员中心
    kShowExperienceVc       = 46,       //体验版会员自动续费
    kShowHomeViewC          = 47,       //首页
    kShowMySceneListVc      = 48,       //我的作品页
    kShowMyCenter           = 49,       //个人中心首页
    kShowCouponList         = 50,       //可用优惠券列表
    kTurnApplet             = 51,       //跳转小程序
    kShowDaySign            = 52,       //跳转原生签到页面
    kVideoSelfie            = 53,       //跳转模板录频
    kSupplyInfo             = 54,       //跳转补充信息界面
    kShowCreateDetial       = 55,       //跳转快捷二级创建页面
    kShowRedRainActivity    = 56,       //红包雨活动，这个主要是运营配置的链接
    kShowRedRainTurn        = 57,       //红包雨活动wap与app交互跳转
    kCreateEmptyLongPage    = 58,       //长页空白创建
    kQuickCreateTools       = 59,       //小工具快捷创建
    kShowCreatToolsView     = 60,       //工作台（+点击）
    kShowCommunityViewC     = 61,       //内容社区
    kShowNewUserGift        = 101,      //ios专属、新用户领取礼包
    
    kShowAllChannelList     = 999999    //跳转全部频道页(非运营定义)
};

enum {
    kPositionIdChannelH5 = 303,
    kPositionIdChannelForm = 300,
    kPositionIdChannelLightDesign = 302,
    kPositionIdChannelVideo = 1103,
    kPositionIdChannelLongPage = 1175,

    kPositionIdWorkbenchH5 = 1097,
    kPositionIdWorkbenchForm = 1098,
    kPositionIdWorkbenchLightDesign = 1099,
    kPositionIdWorkbenchVideo = 1103,
    kPositionIdWorkbenchLongPage = 1177,

    kPositionIdRecommend = 101,
};

typedef enum : NSUInteger {
    kSceneManagerTypeEdit    = 1000,   //编辑
    kSceneManagerTypeSet,               //设置
    kSceneManagerTypeOpen,          //打开
    kSceneManagerTypeDataSpread,        //传播统计
    kSceneManagerTypeDataForm,          //表单数据
    kSceneManagerTypeCopy,              //复制
    kSceneManagerTypeDelete,            //删除
    kSceneManagerTypeReomoveAdFlowPacket,   //去广告流量包
    kSceneManagerTypeCustomLoading,          //自定义加载
    kSceneManagerTypeAudit,     //审核
//    kSceneManagerTypeRemoveLstPage,
    kSceneManagerTypeSafe,          //作品保障
//    kSceneManagerTypePreviewDelAdv, //预览去广告

} SceneManagerType;
#pragma mark 通知
//改变表单表格标题
#define FormsEditCellChangeTitleNotification  @"FormsEditCellChangeTitleNotification"
//改变表单提交反馈提示
#define FeedBackVIewChangeTypeNotification  @"FeedBackVIewChangeTypeNotification"
//改变表单提交反馈图片
#define FeedBackVIewChangeImageNotification  @"FeedBackVIewChangeImageNotification"
//取消表单提交设置
#define FeedBackVIewChangeCancelNotification @"FeedBackVIewChangeCancelNotification"


//开通会员成功
#define kMemberOpenSuccessNotification  @"kMemberOpenSuccessNotification"
//开通超级会员成功
#define kSuperMemberOpenSuccessNotification  @"kSuperMemberOpenSuccessNotification"
#define kClientTableCellHeight         72
#define kClinetDetailViewCellHeight    55
#define kSceneDetailViewCellHeight     50
#define kRemarkTableCellHeight         60
#define kUserCenterTableCellHeight     50


#define kActivityEdgeWidth             40

#define kMainTitleSize                 18
#define kFont_Size_17                  17
#define kTitleSize                     16
#define kFont_Size_15                  15
#define kContentSize                   14
#define kFont_Size_13                  13
#define kDetailSize                    12
#define kFont_Size_11                  11
#define kDateSize                      10
#define kFont_Size_8                   8
#define kFont_Size_20                  20
#define kFont_Size_36                  36
#define kFont_Size_9                    9

#define kStatisticsKey                @"9c76f62ebc"//百度移动统计key
#define kWeiXinAppKey                 @"wx981a6a055dee4b5a"
#define kWeiXinAppLink                @"https://appweb.eqxiu.com/"
#define kMagicWindowKey               @"CV5DSQ0X6MIURCLY84XZ3RN0RIQ2IC9D"

#define kWeiBoAppKey                  @"1113259712"
#define kWeiBoSecret                  @"cd5bfadf5e848b24f3d80bd8975c0784"

#define kQQAppKey                     @"101149132"
#define kQQSecret                     @"5056ba763fe7c22a45b90fdd10d1d559"

#define kFacebookAppKey               @"840352739366416"

#define kGrowingIOKey                 @"a17a66c1107ba80b"//没用了
#define kJPushAppKey                  @"59818793b453d6a001c81a85"

#define kBuglyAppID                   @"290948d08c"

#define kShanYanAppId                 @"odvV9YMX"
#define kShanYanAppKey                @"SWw98Juc"
#define kShanYanCl_SDK_URL            @"https://api.253.com/" // 运营商接口 正式


#define kMainColorStr                 @"#1593FF"
#define kDescTitleColorStr            @"#9b9b9b"
#define kTipTextColorStr              @"#76838f"
#define kHexStringColorStr            @"#08a1ef"
#define kTintColorStr                 @"#44cb83"
#define klableColorStr2               @"#37474f"
#define kBgColorStr2                  @"#ccd5db"
#define kPlaceholderColorStr          @"#c7c7cd"
#define kTextColorStr3                @"#a3afb7"
#define kEditBgColorStr               @"#EDEFF3"
#define kFormEditBgColorStr           @"#2f2f33"
#define kEditBottomColoStr            @"#202023"
#define kEditMenuTitleColorStr        @"#aeacb7"
#define kEditEffectBtnColorStr        @"#242424"
#define kNewBottomIconColorStr        @"#1593FF"
#define kMusicFreeColorStr            @"#48d5b2"
#define kMusicBuyBtnColorStr          @"#ffaf3c"
#define kGradientSecColorStr          @"#27bcff"

#define kLineColorStr                 @"#e0e0e0"
#define kLineBGColorStr               @"#e6e6e6"
#define kLineColoStrEE                @"#eeeeee"
#define kLine3d3d44                   @"#3d3d44"
#define kBordLineColorStr             @"#ececec"
#define kBordLineColorStrB            @"#ebebeb"
#define kBorderColorStr               @"#bdbdbd"
#define kBorderColorStrD              @"#dbdbdb"
#define kBorderColorXD                @"#ccd5db"
#define kBorderColorWhite             @"#979797"
#define kBorderColorD9                @"#d9d9d9"

#define kBlackColorStr                @"#000000"
#define kBlackColorStr1               @"#111111"
#define kBlackColorStr2               @"#222222"
#define kBlackColorStr3               @"#333333"
#define kBlackColorStr4               @"#444444"
#define kBlackColorStr5               @"#555555"
#define kBlackColorStr6               @"#666666"
#define kBlackColorStr8               @"#888888"
#define kBlockColorStr9               @"#999999"
#define kBlockColorStr3E45            @"#3E3E45"

#define kWhiteColorStrC               @"#cccccc"
#define kWhiteColotStrF2              @"#F2F2F2"
#define kWhiteColorStrF4              @"#f4f4f4"
#define kWhiteColorStrF5              @"#f5f5f5"
#define kWhiteColorStrFa              @"#fafafa"
#define kWhiteColorStrF6              @"#f6f6f6"
#define kWhiteColorStrF0              @"#f0f0f0"
#define kWhiteColorStrF7              @"#f7f7f7"
#define kWhiteColorStrF7FA            @"#F6F7FA"
#define kWhiteColorStrF9              @"#F9F9F9"

#define kGrayColorStr9a               @"#9a9a9a"
#define kGrayColorStr75               @"#757575"
#define kGrayColotStrC1               @"#c1c1c1"
#define kGtayColorStrD8               @"#d8d8d8"
#define kGrayColorStr8D               @"#8d8c8d"
#define kGrayColorStr61               @"#616161"
#define kGrayColorStrA3AD             @"#A5A3AD"
#define kGrayColorStrEFEFF4           @"#EFEFF4"

#define kBorderColorStrB              @"#bbbbbb"

#define kRoyalblueColorStr            @"#31364a"
#define kRoyalblueColorStr21          @"#212636"
#define kYellowBgColor                @"#ffedcc"
#define kYellowTextColor              @"#ffad15"
#define kYellowLineColor              @"#cfa56a"


#define kLightEditBgColorStr          @"#EDEFF3"
#define kLightEditBorderColorStr      @"#D5DFE5"
#define kLightEditShadowColorStr      @"#2C323D"

#define kNewBlueBgColorStr            @"#f5f6f9"

#define kAppLanguageChange            @"AppLanguageChanged"
#define kAppExitLogin                 @"AppExitLoginNow"
#define kLoginOrRegiterSucced         @"LoginOrRegiterSucced"
#define kRechargeSucced               @"RechargeSucced"
#define kRechargeDelay                @"RechargeDelay"
#define kRechargeFailed               @"RechargeFailed"

#define kRefreshSceneList             @"RefreshSceneList"
#define kRefreshAppSceneNum           @"-1"
#define kRefreshPcSceneNum            @"0"
#define NOTI_NAV_HIDDEN               @"kNotiNavHidden"
#define NOTI_TRANSTER_IMAGE           @"KNotiTransterImage"
#define NOTI_STITCHINGPIC_IMAGE       @"KNotiStitchingPicImage"
#define kBuyMembershipSucced          @"BuyMembershipSucced"
#define kFinishSetSceneShowShare      @"kFinishSetSceneShowShare"
#define kFinishSetAuditSceneShare     @"kFinishSetAuditSceneShare"
#define kFinishBindPhone              @"kFinishBindPhone"



#define kLeftRecommendViewStr         @"/home/leftRecommendView"
#define kCollectionViewStr            @"/home/mine/myCollectionView"
#define kCouponViewStr                @"/home/mine/couponView"
#define kMyOrderViewStr               @"/home/mine/myOrderView"
#define kPaymentViewStr               @"/baseWebView/paymentConfirmationView"



#define KREDBAG_RECHARGE 2  //红包_充值渠道
#define KREDBAG_ORDER 1     //红包_订单



#define kMiniProgramForm              @"gh_4e35a11ebd49" //小易表单
#define kMiniProgramVideo             @"gh_8f34581a4e75" //小易营销视频
#define kMiniProgramH5                @"gh_89f6e942bfeb" //易企秀H5小程序

#define kMaxAdvertH5Banner                  @"82"      //中台广告位H5bannerid
#define kMaxAdvertH5Operation               @"83,84,85,86,87,218,219,220,221,222"  //中台广告位H5的圆形运营位id
#define kMaxAdvertH5TipsBanner              @"196"         //中台广告位H5小长条

#define kMaxAdvertVideoBanner               @"99"      //中台广告位视频bannerid
#define kMaxAdvertVideoOperation            @"100,101,102,103,104,223,224,225,226,227"  //中台广告位视频的圆形运营位id
#define kMaxAdvertVideoTipsBanner           @"197"         //中台广告位视频小长条

#define kMaxAdvertLightDesignBanner         @"172"         //中台广告位海报bannerid
#define kMaxAdvertLightDesignOperation      @"173,174,175,176,177,178,179,180,181,182"         //中台广告位海报圆形运营位
#define kMaxAdvertLightDesignTipsBanner     @"183"         //中台广告位海报小长条

#define kMaxAdvertEasyFormBanner            @"184"         //中台广告位易表单bannerid
#define kMaxAdvertEasyFormOperation         @"185,186,187,188,189,190,191,192,193,194"         //中台广告位易表单圆形运营位
#define kMaxAdvertEasyFormTipsBanner        @"195"         //中台广告位易表单小长条

#define kMaxAdvertLongPageBanner            @"153"         //中台广告位长页banner
#define kMaxAdvertLongPageOperation         @"154,155,156,157,158,230,231,232,233,234" //中台广告位长页圆形运营位
#define kMaxAdvertLongPageMiniBanner        @"159"         //中台广告位长页小黄条


#define kMaxAdvertRecommendBanner           @"198"         //中台广告位推荐页bannerid
#define kMaxAdvertRecommendOperation        @"199,200,201,202,203,204,205,206,207,208"         //中台广告位推荐页圆形运营位
#define kMaxAdvertRecommendTipsBanner       @"209"         //中台广告位推荐页小长条

#define kMaxAdvertHomePopBox                @"210"      //首页-运营弹窗
#define kMaxAdvertFloatingBanner            @"211"      //首页-右下角运营位
#define kMaxAdvertVisitorPopBox             @"228"      //首页-游客模式弹窗
#define kMaxAdvertDropDownBanner            @"229"      //首页-下拉运营位

#define kMaxAdvertOpenScreen                @"212"      //开屏广告


#define kMaxAdvertAutoRenewal               @"213"      //管理自动续费
#define kMaxAdvertMemberCenterTop           @"214"      //会员中心顶部banner
#define kMaxAdvertMemberCenterTheme         @"215"      //会员中心专题banner
#define kMaxAdvertSuperMemberCenterTheme    @"216"      //超级会员中心专题banner
#define kMaxAdvertCompanyMemberCenterTop    @"217"      //企业会员中心专题banner


#define kMaxAdvertH5ListBanner                    @"106"//H5作品列表banner
#define kMaxAdvertLightDesignListBanner           @"107"
#define kMaxAdvertLongpageListBanner              @"145"
#define kMaxAdvertFormListBanner                  @"108"
#define kMaxAdvertVideoListBanner                 @"109"
#define kMaxAdvertCreateToolsBanner               @"152"//工具创建页banner

#ifndef fequal

#define fequal(a,b) (fabs((a) - (b)) < FLT_EPSILON)
#endif

#import "CommUtls.h"



#endif
