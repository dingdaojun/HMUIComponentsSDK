//  WVJBBusinessProtocol.h
//  Created on 2018/7/30
//  Description 适配器能力protocol

//  Copyright © 2018年 Huami inc. All rights reserved.
//  @author luoliangliang(luoliangliang@huami.com)

#import <Foundation/Foundation.h>
#import "WVJBCommon.h"
#import "WVJBShareViewModel.h"
#import "WebViewJavascriptBridgeBase.h"

@protocol WVJBBusinessProtocol <NSObject>

@optional
/** 注册自定义userAgent*/
- (void)registerCustomUserAgent;
/** 进入指定控制器界面 */
- (void)navigationToPosition:(NSString *)actionName navigationVC:(UINavigationController *)nav;
/** 加载状态打点 (Success, LoadFail, OffLine)*/
- (void)webLoadEvent:(NSString *)event;
/** 排斥登录 */
- (void)loginMutexWithType:(LoginType)loginType;
/** 同步表盘 */
- (void)syncWatchSurface:(NSDictionary *)watchConfig callBack:(WVJBResponseCallback)callBack;
/** 写入设备通知提醒 */
- (void)writeDeviceNotice:(NSDictionary *)noticeDic callBack:(WVJBResponseCallback)callBack;
/** 获取指定设备相关信息 */
- (void)fetchMifitInfo:(JBContentType)contentType callBack:(WVJBResponseCallback)callBack;
/** 微信支付 */
- (void)wechatPayWithOrder:(NSDictionary *)payOrder;
/** 设备分享配置 (H5页面点击分享 & 右上角全平台分享) */
- (void)shareH5WithEvent:(BOOL)isH5ButtonEvent shareViewModel:(WVJBShareViewModel *)shareViewModel;

#pragma mark - 国际化翻译字段(默认中文)

/**加载中*/
@property (readonly, nonatomic) NSString *load_Field;
/**无数据*/
@property (readonly, nonatomic) NSString *noData_Field;
/**无网络*/
@property (readonly, nonatomic) NSString *noNetwork_Field;
/**加载失败*/
@property (readonly, nonatomic) NSString *loadFail_Field;
/**无网络权限*/
@property (readonly, nonatomic) NSString *noAccess_Field;
/**检查网络*/
@property (readonly, nonatomic) NSString *checkNetwork_Field;

@end
