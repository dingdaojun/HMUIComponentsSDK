# HMStatistics

该类库为华米公司内部的统计库，用于替换其他三方的打点统计实现。按照具体的功能大致分为：实名统计、匿名统计、奔溃收集。其中外部接口主要在 **HMStatisticsLog.h** 文件中。

## 实名与匿名的区别

两者间的主要区别：实名统计会记录用户的 HuamiID ，将打点事件与特定用户进行关联；匿名统计则将时间与 DeviceID 进行关联。另外为了防止未知法律风险，两个渠道采用了两套独立的代码与数据库。

## 上传策略

主要的上传策略为：定时上传、启动时上传、实时上传，其中实时上传仅在 Debug 模式下生效。另外为了提高数据的时效性，我在 APP 进入后台时会进行补充上传 （数据量大于 20 或者包含一天前的数据）。

## 无埋点

无埋点实现主要通过 Runtime 机制实现，而且所有无埋点统计均为匿名统计。

## 安装方式

HMStatistics is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

HMStatistics 支持 [Cocoapod](http://cocoapods.org) 方式安装：

```ruby
pod 'HMStatistics'
```

## 使用

可以参照代码中的 Example 示例工程查看具体使用方式。

启动服务：

```objective-C
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    HMStatisticsConfig *config = [[HMStatisticsConfig alloc] init];

    config.reportPolicy = HMStatisticsReportPolicySendInterval;
    config.appID = @"3BA5260C549E299FDEAE705A";
    config.secret = @"fbe6a73771185e5c428c60f2e8cb655f";
    config.huamiID = @"01";

    // 服务类型可以根据具体情况设置
    [HMStatisticsLog startWithConfig:config andTypes:HMStatisticsServiceTypeAnonymous|HMStatisticsServiceTypeNamed];

    return YES;
}
```

当发生用户退出的时候需要停止实名收集：

```objective-C
[HMStatisticsLog stopLogServiceWithTypes:HMStatisticsServiceTypeNamed];
```

## 更新记录

### 1.2.0
修复跨版本升级过程中，前一版本的数据会使用新版本上下文进行上传。导致一部分有效数据变为了脏数据。主要改动代码：

1. 新增 Context 上下文表
2. 原有事件表增加 contextID 字段将事件与 context 进行关联
3. 所有数据库操作全部改为异步安全操作
4. 修改内部数据库操作 API 与逻辑

## 作者

BigNerdCoding, bignerdcoding@gmail.com

## License

HMStatistics is available under the MIT license. See the LICENSE file for more info.
