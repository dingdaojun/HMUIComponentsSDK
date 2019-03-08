//
//  HMServiceAPITypeDefine.h
//  HMNetworkLayer
//
//  Created by 李宪 on 26/4/2017.
//  Copyright © 2017 lixian@huami.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=47
 */
typedef NS_ENUM(NSUInteger, HMServiceAPIDeviceType) {
    HMServiceAPIDeviceTypeBand      = 0,        // 手环
    HMServiceAPIDeviceTypeScale,                // 秤
    HMServiceAPIDeviceTypePhone,                // 手机计步
    HMServiceAPIDeviceTypeShoe,                 // 跑鞋（智芯2代，米家跑鞋）
    HMServiceAPIDeviceTypeWatch,                // 手表
};
#define HMServiceAPIDeviceTypeParameterAssert(x)    NSParameterAssert(x == HMServiceAPIDeviceTypeBand ||    \
                                                                      x == HMServiceAPIDeviceTypeScale ||    \
                                                                      x == HMServiceAPIDeviceTypePhone ||    \
                                                                      x == HMServiceAPIDeviceTypeShoe ||    \
                                                                      x == HMServiceAPIDeviceTypeWatch)

/**
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=47
 */
typedef NS_ENUM(NSUInteger, HMServiceAPIDeviceSource) {
    HMServiceAPIDeviceSourceBand1           = 0,        // 手环1代
    HMServiceAPIDeviceSourceBand1A          = 5,        // 手环1A
    HMServiceAPIDeviceSourceBand1S          = 4,        // 手环1S
    HMServiceAPIDeviceSourceMiDongBand1     = 6,        // 米动手环1代
    HMServiceAPIDeviceSourceBandPro         = 8,        // Pro手环
    HMServiceAPIDeviceSourceBandRocky       = 9,        // Rocky手环
    HMServiceAPIDeviceSourceBandNFC         = 10,       // NFC手环
    HMServiceAPIDeviceSourceBandQinLing     = 11,       // 秦岭手环
    HMServiceAPIDeviceSourceBandChaoHu      = 12,       // 巢湖手环
    HMServiceAPIDeviceSourceBandTempo       = 13,       // Tempo手环
    HMServiceAPIDeviceSourceBand2Indian     = 14,       // Pro手环印度版
    HMServiceAPIDeviceSourceWuhan           = 15,       // 武汉手环
    HMServiceAPIDeviceSourceBeats           = 16,       // tempo + gps
    HMServiceAPIDeviceSourceChongqing       = 17,       // wuhan + NFC
    HMServiceAPIDeviceSourceBeatsP          = 18,       // tempo + gps + NFC + DMIC

    HMServiceAPIDeviceSourceScale1          = 1,        // 体重秤1代
    HMServiceAPIDeviceSourceBodyFatScale    = 101,      // 体脂秤
    
    HMServiceAPIDeviceSourceShoe1           = 3,        // 跑鞋一代
    HMServiceAPIDeviceSourceChildrenShoe    = 304,      // 儿童跑鞋
    HMServiceAPIDeviceSourceLightShoe       = 305,      // 轻跑鞋
    HMServiceAPIDeviceSourceSprandiShoe     = 306,      // Sprandi智能健步鞋
    HMServiceAPIDeviceSourceShoeMiJia       = 307,      // 米家跑鞋
    
    HMServiceAPIDeviceSourceWatchHuanghe    = 400,      // 黄河手表
    HMServiceAPIDeviceSourceWatchEverest    = 401,      // 珠峰手表
    HMServiceAPIDeviceSourceWatchEverest2S  = 402,      // 珠峰2S手表
    HMServiceAPIDeviceSourceCoreMotion      = 7,        // iOS CoreMotion
};
// 如果断言崩溃请联系lixian@huami.com
#if DEBUG
#define HMServiceAPIDeviceSourceParameterAssert(x)      NSParameterAssert(x == HMServiceAPIDeviceSourceBand1 ||    \
                                                                            x == HMServiceAPIDeviceSourceBand1A ||    \
                                                                            x == HMServiceAPIDeviceSourceBand1S ||    \
                                                                            x == HMServiceAPIDeviceSourceMiDongBand1 ||    \
                                                                            x == HMServiceAPIDeviceSourceBandPro ||     \
                                                                            x == HMServiceAPIDeviceSourceBandRocky ||     \
                                                                            x == HMServiceAPIDeviceSourceBandNFC ||     \
                                                                            x == HMServiceAPIDeviceSourceBandQinLing ||     \
                                                                            x == HMServiceAPIDeviceSourceBandChaoHu ||     \
                                                                            x == HMServiceAPIDeviceSourceBandTempo ||     \
                                                                            x == HMServiceAPIDeviceSourceScale1 ||     \
                                                                            x == HMServiceAPIDeviceSourceBodyFatScale ||     \
                                                                            x == HMServiceAPIDeviceSourceShoe1 ||     \
                                                                            x == HMServiceAPIDeviceSourceChildrenShoe ||     \
                                                                            x == HMServiceAPIDeviceSourceLightShoe ||     \
                                                                            x == HMServiceAPIDeviceSourceSprandiShoe ||     \
                                                                            x == HMServiceAPIDeviceSourceShoeMiJia ||     \
                                                                            x == HMServiceAPIDeviceSourceWatchHuanghe ||     \
                                                                            x == HMServiceAPIDeviceSourceWatchEverest ||     \
                                                                            x == HMServiceAPIDeviceSourceWuhan ||     \
                                                                            x == HMServiceAPIDeviceSourceBeats ||     \
                                                                            x == HMServiceAPIDeviceSourceChongqing ||     \
                                                                            x == HMServiceAPIDeviceSourceBeatsP ||     \
                                                                            x == HMServiceAPIDeviceSourceCoreMotion)
#else 
#define HMServiceAPIDeviceSourceParameterAssert(x)      NSParameterAssert(x == x)
#endif

/**
 @see http://showdoc.private.mi-ae.cn/index.php?s=/7&page_id=47
 PS：后来发现实际存在很多没有写入文档的值，所以此处定义只是用来帮助阅读，类型在代码里不一定有实际价值。
 后期如果发现确实没有用于可以改成 typedef
 */
typedef NS_ENUM(NSUInteger, HMServiceAPIProductVersion) {
    HMServiceAPIProductVersionTaipinghu        = 258,      // 太平湖
    HMServiceAPIProductVersionArc              = 256,      // Arc
    HMServiceAPIProductVersionHuashanNFC       = 256,      // 黄山NFC
    HMServiceAPIProductVersionQinling          = 256,      // 秦岭
    HMServiceAPIProductVersionChaohu           = 256,      // 巢湖
    HMServiceAPIProductVersionWeighingScale    = 36,       // 体重秤
    HMServiceAPIProductVersionBodyFatScale     = 0,        // 体脂秤
};
// 如果断言崩溃请联系lixian@huami.com
#if DEBUG
#define HMServiceAPIProductVersionParameterAssert(x)    NSParameterAssert(x == HMServiceAPIProductVersionTaipinghu ||    \
                                                                          x == HMServiceAPIProductVersionArc ||    \
                                                                          x == HMServiceAPIProductVersionHuashanNFC ||    \
                                                                          x == HMServiceAPIProductVersionQinling ||    \
                                                                          x == HMServiceAPIProductVersionChaohu ||     \
                                                                          x == HMServiceAPIProductVersionWeighingScale ||   \
                                                                          x == HMServiceAPIProductVersionBodyFatScale)
#else 
#define HMServiceAPIProductVersionParameterAssert(x)    NSParameterAssert(x == x)
#endif
