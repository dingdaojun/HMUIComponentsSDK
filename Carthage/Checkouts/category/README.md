# HMCategory库

## 目标
HMCategory库，是将一些常用的Category方法归纳起来，统一放到pod库里面，实现统一管理、统一调用！目的是解决目前各个项目，甚至项目内部各个模块之间，各自定义一套category，使用混乱、代码无法维护、无法统一等问题！同时，还为其他的库提供了可靠的工具。

## 原则
HMCategory库作为日常开发的category集成工具，并不是任何category类都可以放置到HMCategory库里的。同样，放到HMCategory库里的文件，也不是随便乱放的，需要遵循一定的原则:
1. 通用性原则. 只有各个项目经常用到的一些category方法，才能放到HMCategory库.
2. 项目性原则. 只在某个项目里面大范围用到的category方法，有两种处理方式:
```
a.放置到项目本身公用的目录下，以供开发人员调用.
b.放置到HMCategory库里对应的项目subspec下.
```
3. 模块性原则. 只在某一个模块里面才用到的category方法，该类category就放在对应的模块目录下，这类是不允许放置到HMCategory库里的.
4. 归类性原则. 类文件存放在相应的目录文件夹里面(没有就建一个).
5. 命名性原则. 每个文件，建议具有自己功能性的名字.
6. 注释性原则. 每个文件的.h文件，建议增加文件注释性文字，已解释文件是干嘛的，同时，.h的Api，建议全部都要注释，以便调用者使用.

## 使用
` pod 'HMCategory', '~> 0.2.6' `

```
这里会一直保持和最新pod版本同步.
```

## Api
### FoundationKit
#### NSArray
##### NSArray+HMJson
> 数组转JSON

```
/**
 转JSON字符串

 @param isFormat 是否去掉无用的符号(回车\换行\跳格)
 @return NSString
 */
```
- -(NSString *)toJSON:(BOOL)isFormat;

```
/**
 转JSON Data

 @return NSData
 */
```
- -(NSData *)toJSONData;

##### NSArray+HMSafe
> 安全获取和设置array.

```
/**
 安全的获取数据，保证不越界
 
 @param index index
 @return id
 */
```
- -(id)objectAtSafeIndex:(NSInteger)index;

```
/**
 安全添加
 
 @param object 元素
 */
```
- -(void)addSafeObject:(id)object;

```
/**
 安全插入
 
 @param object 元素
 @param index index
 */
```
- -(void)insertSafeObject:(id)object atIndex:(NSInteger)index;

```
/**
 安全删除
 
 @param index index
 */
```
- -(void)removeObjectAtSafeIndex:(NSInteger)index;

#### NSData
##### NSData+HexDump
> 转字符串

```
/**
 转字符串

 @return NSString
 */
```
- -(NSString *)hexval;

##### NSData+HMMD5
> md5

```
/**
 获取MD5加密字符串
 */
```
- @property (nonatomic, copy, readonly) NSString *md5;

#### NSDate
##### NSDate+HMAdjust
> NSDate调整

```
/**
 在当前时间的基础上，追加时分，得到的NSDate
 
 @param hours 时
 @param minutes 分
 @return NSDate
 */
```
- +(NSDate *)dateWithHours:(NSInteger)hours minutes:(NSInteger)minutes;

```
/**
 追加年数
 
 @param years 年数
 @return NSDate
 */
```
- -(NSDate *)dateByAddingYears:(NSInteger)years;

```
/**
 减少年数
 
 @param years 年数
 @return NSDate
 */
```
- -(NSDate *)dateBySubtractingYears:(NSInteger)years;

```
/**
 追加月数
 
 @param months 月数
 @return NSDate
 */
```
- -(NSDate *)dateByAddingMonths:(NSInteger)months;

```
/**
 减少月数
 
 @param months 月数
 @return NSDate
 */
```
- -(NSDate *)dateBySubtractingMonths:(NSInteger)months;

```
/**
 追加天数
 
 @param days 天数
 @return NSDate
 */
```
- -(NSDate *)dateByAddingDays:(NSInteger)days;

```
/**
 减少天数
 
 @param days 天数
 @return NSDate
 */
```
- -(NSDate *)dateBySubtractingDays:(NSInteger)days;

```
/**
 追加小时
 
 @param hours 小时
 @return NSDate
 */
```
- -(NSDate *)dateByAddingHours:(NSInteger)hours;

```
/**
 减少小时
 
 @param hours 小时
 @return NSDate
 */
```
- -(NSDate *)dateBySubtractingHours:(NSInteger)hours;

```
/**
 追加分钟数
 
 @param minutes 分钟数
 @return NSDate
 */
```
- -(NSDate *)dateByAddingMinutes:(NSInteger)minutes;

```
/**
 减少分钟数
 
 @param minutes 分钟数
 @return NSDate
 */
```
- -(NSDate *)dateBySubtractingMinutes:(NSInteger)minutes;

```
/**
 追加秒数
 
 @param seconds 秒数
 @return NSDate
 */
```
- -(NSDate *)dateByAddingSeconds:(NSInteger)seconds;

```
/**
 减少秒数
 
 @param seconds 秒数
 @return NSDate
 */
```
- -(NSDate *)dateBySubtractingSeconds:(NSInteger)seconds;

##### NSDate+HMCompare
> NSDate日期时间比较

```
/**
 是否同一天
 
 @param anotherDate NSDate
 @return YES ? 同一天 : 不是同一天
 */
```
- -(BOOL)isEqualToDateIgnoringTime:(NSDate *)anotherDate;

```
/**
 是否今天
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isToday;

```
/**
 是否明天的日期
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isTomorrow;

```
/**
 是否昨天日期
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isYesterday;

```
/**
 是否在同一个礼拜
 
 @param anotherDate NSDate
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isSameWeekAsDate:(NSDate *)anotherDate;

```
/**
 和当前日期是否在一个礼拜
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isThisWeek;

```
/**
 是否是当前日期所在礼拜的下个礼拜
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isNextWeek;

```
/**
 是否是当前日期所在礼拜的上个礼拜
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isLastWeek;

```
/**
 是否在同一个月
 
 @param anotherDate NSDate
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isSameMonthAsDate:(NSDate *)anotherDate;

```
/**
 是否和当前日期是在同一个月
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isThisMonth;

```
/**
 是否是当前日期的下个月
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isNextMonth;

```
/**
 是否是当前日期的上个月
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isLastMonth;

```
/**
 是否同一年
 
 @param anotherDate NSDate
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isSameYearAsDate:(NSDate *)anotherDate;

```
/**
 是否与当前日期为同一年
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isThisYear;

```
/**
 是否是当前日期下一年
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isNextYear;

```
/**
 是否当前日期上一年
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isLastYear;

```
/**
 是否早于anotherDate
 
 @param anotherDate NSDate
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isEarlierThanDate:(NSDate *)anotherDate;

```
/**
 是否迟于anotherDate
 
 @param anotherDate NSDate
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isLaterThanDate:(NSDate *)anotherDate;

```
/**
 是否是以后的时间
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isInFuture;

```
/**
 是否是过去的时间
 
 @return YES ? 是 : 不是
 */
```
- -(BOOL)isInPast;

```
/**
 是否在两个日期之间，不考虑时间
 
 @param dateStart 开始NSDate
 @param dateEnd 结束NSDate
 @return YES ? 是 ： 不是
 */
```
- -(BOOL)isBetweenDatesIgnoringTime:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;

```
/**
 是否在两个日期时间之间
 
 @param dateStart 开始NSDate
 @param dateEnd 结束NSDate
 @return YES ? 是 ： 不是
 */
```
- -(BOOL)isBetweenDates:(NSDate *)dateStart dateEnd:(NSDate *)dateEnd;

```
/**
 当前时间与格林尼治时间的差值
 
 @return 小时
 */
```
- -(NSInteger)hoursFromGMTDate;

##### NSDate+HMDetail
> NSDate日期时间的详情

```
/**
 接近的小时
 */
```
- @property (readonly) NSInteger nearestHour;

```
/**
 小时
 */
```
- @property (readonly) NSInteger hour;

```
/**
 分钟
 */
```
- @property (readonly) NSInteger minute;

```
/**
 秒
 */
```
- @property (readonly) NSInteger seconds;

```
/**
 天
 */
```
- @property (readonly) NSInteger day;

```
/**
 月
 */
```
- @property (readonly) NSInteger month;

```
/**
 当前月的第几周
 */
```
- @property (readonly) NSInteger weekOfMonth;

```
/**
 星期几
 */
```
- @property (readonly) NSInteger weekday;

```
/**
 年
 */
```
- @property (readonly) NSInteger year;

```
/**
 时间戳
 */
```
- @property (readonly) long long milliSecondsSince1970;

##### NSDate+HMExtremes
> NSDate极端区间操作

```
/**
 开始于分钟，秒数为0 eg: 2019-10-18 18:19:00
 
 @return NSDate
 */
```
- -(NSDate *)startOfCurrentMinute;

```
/**
 结束于分钟，秒数为59 eg: 2019-10-18 18:19:59
 
 @return NSDate
 */
```
- -(NSDate *)endOfCurrentMinute;

```
/**
 开始于小时，分钟为0 eg: 2019-10-18 18:00:00
 
 @return NSDate
 */
```
- -(NSDate *)startOfCurrentHour;

```
/**
 结束于小时，分钟秒钟都为59 eg: 2019-10-18 18:59:59
 
 @return NSDate
 */
```
- -(NSDate *)endOfCurrentHour;

```
/**
 开始于天，小时分钟秒数都为0，eg: 2019-10-18 00:00:00
 
 @return NSDate
 */
```
- -(NSDate *)startOfDay;

```
/**
 结束于天，小时分钟秒数都为极值，eg: 2019-10-18 23:59:59
 
 @return NSDate
 */
```
- -(NSDate *)endOfDay;

```
/**
 开始于星期, 日期所属星期的星期一那天，时分秒为0(具体参看单元测试)
 
 @return NSDate
 */
```
- -(NSDate *)startOfWeek;

```
/**
 结束于星期天，时为23，分秒为59(具体参看单元测试)
 
 @return NSDate
 */
```
- -(NSDate *)endOfWeek;

```
/**
 开始于月, eg: 2019-10-01 00:00:00
 
 @return NSDate
 */
```
- -(NSDate *)startOfMonth;

```
/**
 结束于月, eg: 20119-10-31 23:59:59
 
 @return NSDate
 */
```
- -(NSDate *)endOfMonth;

##### NSDate+HMGenerate
> NSDate生成

```
/**
 日历
 
 @return NSCalendar
 */
```
- +(NSCalendar *)currentCalendar;

```
/**
 根据字符串创建NSDate，字符串格式必须为: 2014-09-19
 
 @param dateFormatString 时间字符串
 @return NSDate
 */
```
- +(NSDate *)dateFromFormateString:(NSString *)dateFormatString;

```
/**
 根据字符串创建NSDate，字符串格式必须与后面所选formate一致

 @param dateString 时间字符串
 @param dateFormat 格式
 @return NSDate
 */
```
- +(NSDate *)dateFromFormateString:(NSString *)dateString dateFormat:(HMDateFormat)dateFormat;

##### NSDate+HMRetrieving
> NSDate检索

```
/**
 得到当前日期在给定日期之后的秒钟数
 
 @param anotherDate NSDate
 @return 秒数
 */
```
- -(NSInteger)secondsAfterDate:(NSDate *)anotherDate;

```
/**
 得到当前日期在给定日期之前的秒钟数
 
 @param anotherDate NSDate
 @return 秒数
 */
```
- -(NSInteger)secondsBeforeDate:(NSDate *)anotherDate;

```
/**
 得到当前日期在给定日期之后的分钟数
 
 @param anotherDate NSDate
 @return 分钟数
 */
```
- -(NSInteger)minutesAfterDate:(NSDate *)anotherDate;

```
/**
 得到当前日期在给定日期之前的分钟数
 
 @param anotherDate NSDate
 @return 分钟数
 */
```
- -(NSInteger)minutesBeforeDate:(NSDate *)anotherDate;

```
/**
 得到当前日期在给定日期之后的小时数
 
 @param anotherDate NSDate
 @return 小时数
 */
```
- -(NSInteger)hoursAfterDate:(NSDate *)anotherDate;

```
/**
 得到当前日期在给定日期之前的小时数
 
 @param anotherDate NSDate
 @return 小时数
 */
```
- -(NSInteger)hoursBeforeDate:(NSDate *)anotherDate;

```
/**
 得到当前日期在给定日期之后的天数
 
 @param anotherDate NSDate
 @return 天数
 */
```
- -(NSInteger)daysAfterDate:(NSDate *)anotherDate;

```
/**
 得到当前日期在给定日期之前的天数
 
 @param anotherDate NSDate
 @return 天数
 */
```
- -(NSInteger)daysBeforeDate:(NSDate *)anotherDate;

```
/**
 得到当前日期在给定日期之后的模糊天数(eg：相差1.95天，就返回2天)
 
 @param anotherDate NSDate
 @return 天数
 */
```
- -(NSInteger)fuzzyDaysAfterDate:(NSDate *)anotherDate;

```
/**
 得到当前日期在给定日期之前的秒钟数(eg：相差1.95天，就返回2天)
 
 @param anotherDate NSDate
 @return 天数
 */
```
- -(NSInteger)fuzzyDaysBeforeDate:(NSDate *)anotherDate;

```
/**
 时区差
 
 @return 小时
 */
```
- -(NSInteger)timeZoneOffsetToDate;

```
/**
 两日期之间的分钟差
 
 @param anotherDate NSDate
 @return 分钟
 */
```
- -(NSInteger)distanceInMinutesToDate:(NSDate *)anotherDate;

```
/**
 两日期之间的天数差
 
 @param anotherDate NSDate
 @return 天
 */
```
- -(NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

```
/**
 两日期之间的月数差
 
 @param anotherDate NSDate
 @return 月
 */
```
- -(NSInteger)distanceInMonthsToDate:(NSDate *)anotherDate;

```
/**
 上个月
 
 @return NSDate
 */
```
- -(NSDate *)preMonthDate;

```
/**
 下个月
 
 @return NSDate
 */
```
- -(NSDate *)nextMonthDate;

```
/**
 上个星期
 
 @return NSDate
 */
```
- -(NSDate *)preWeekDate;

```
/**
 下个星期
 
 @return NSDate
 */
```
- -(NSDate *)nextWeekDate;

```
/**
 昨天
 
 @return NSDate
 */
```
- -(NSDate *)preDayDate;

```
/**
 明天
 
 @return NSDate
 */
```
- -(NSDate *)nextDayDate;

```
/**
 明天日期
 
 @return NSDate
 */
```
- +(NSDate *)tomorrow;

```
/**
 昨天日期
 
 @return NSDate
 */
```
- +(NSDate *)yesterday;

```
/**
 在当前时间比，年龄是多少
 
 @return 年龄
 */
```
- -(NSInteger)age;

```
/**
 与一个NSDate比，年龄多少
 
 @param date NSDate
 @return 年龄
 */
```
- -(NSInteger)ageFromDate:(NSDate *)date;

##### NSDate+HMStringFormat
> NSDate转字符串

```
/**
 字符串 eg: 2019-10-19
 
 @return NSString
 */
```
- -(NSString *)stringWithFormat_yyyyMMdd;

```
/**
 字符串 eg: 2019-10
 
 @return NSString
 */
```
- -(NSString *)stringWithFormat_yyyyMM;

```
/**
 字符串 eg: 10-11
 
 @return NSString
 */
```
- -(NSString *)stringWithFormat_MMdd;

```
/**
 根据日期格式，获取格式化字符串
 
 @param dateFormate HMDateFormat类型
 @return NSString
 */
```
- -(NSString *)stringWithFormat:(HMDateFormat)dateFormate;

##### NSDate+HMSystemTime
> NSDate 12、24小时制处理

```
/**
 是否是24小时制
 
 @return YES ？ 是 ：不是
 */
```
- +(BOOL)is24hourTimeSystem;

#### NSDictionary
##### NSDictionary+HMJson
> 字典转JSON

```
/**
 转JSON

 @param isFormat 是否去掉无用的符号(回车\换行\跳格)
 @return NSString
 */
```
- -(NSString *)toJSON:(BOOL)isFormat;

```
/**
 将Json转NSDictionary

 @param jsonString json
 @return NSDictionary
 */
```
- +(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

##### NSDictionary+HMSafe
> 安全获取和设置object

```
/**
 获取字符串
 
 @param key key
 @return NSString
 */
```
- -(NSString *)stringForKey:(NSString *)key;

```
/**
 获取整型
 
 @param key key
 @return NSInteger
 */
```
- -(NSInteger)integerForKey:(NSString *)key;

```
/**
 获取浮点型
 
 @param key key
 @return float
 */
```
- -(float)floatForKey:(NSString *)key;

```
/**
 获取bool型
 
 @param key key
 @return BOOL
 */
```
- -(BOOL)boolForKey:(NSString*)key;

```
/**
 获取字典
 
 @param key key
 @return NSDictionary
 */
```
- -(NSDictionary *)dictionaryForKey:(NSString *)key;

```
/**
 获取数组
 
 @param key key
 @return NSArray
 */
```
- -(NSArray *)arrayForKey:(NSString *)key;

```
/**
 设置Bool
 
 @param value boolValue
 @param keyName key
 */
```
- -(void)setBool:(BOOL)value forKey:(NSString *)keyName;

```
/**
 设置Float
 
 @param value floatValue
 @param keyName key
 */
```
- -(void)setFloat:(float)value forKey:(NSString *)keyName;

```
/**
 设置Integer
 
 @param value integerValue
 @param keyName key
 */
```
- -(void)setInteger:(NSInteger)value forKey:(NSString *)keyName;

```
/**
 设置安全Value
 
 @param object value
 @param keyName key
 */
```
- -(void)setSafeObject:(id)object forKey:(NSString *)keyName;

#### NSLocal
##### NSLocale+HMLocal
> 本地化

```
/**
 判断是不是中国地区(Only 华米健康)
 
 @return YES ？是 ：不是
 */
```
- +(BOOL)isChinaRegion;

```
/**
 判断是不是中文语言(Only 华米健康)
 
 @return YES ？是 ：不是
 */
```
- +(BOOL)isChinaLanguage;

#### NSNotificationCenter
##### NSNotificationCenter+Block
> NSNotificationCenter 快捷回调

```
/**
 添加observer
 如果observer被释放了，则内部会自动解除订阅。无需手动remove
 */
```
- +(void)addBlockObserver:(id)observer
         event:(NSNotificationName)event
        object:(id)object
         block:(NSNotificationCenterBlockType)block;

```
/**
 为特定event移除某个observer
 */
```
- +(void)removeBlockObserver:(id)observer fromEvent:(NSNotificationName)event;

```
/**
 为所有event移除某个observer
 */
```
- +(void)removeBlockObserver:(id)observer;

#### NSObject
##### NSObject+Async
> 异步

```
/**
 *  Wait to perfom the block, until call leave in body.
 *
 *  @param body Perfom body block, we need call leave in the end of body.
 */
```
- -(void)waitPerfomBlock:(HM_AsyncCallBody)body;

#### NSString
##### NSString+HMAdjust
> 字符串调整

```
/**
 去除字符串两端的空格
 
 @return NSString
 */
```
- -(NSString *)trimEndsSpace;

```
/**
 去除字符串所有的空格
 
 @return NSString
 */
```
- -(NSString *)trimAllSpace;

```
/**
 去除字符串特殊符号 \n \t \r
 
 @return NSString
 */
```
- -(NSString *)trimSpecialCode;

```
/**
 字符串转字典
 
 @param error 错误信息
 @return NSDictionary
 */
```
- -(NSDictionary *)toDictionaryWithError:(NSError **)error;

```
/**
 字符串转数组
 
 @param error 错误信息
 @return NSArray
 */
```
- -(NSArray *)toArrayWithError:(NSError **)error;

##### NSString+HMApp
> 获取app相关数据: App名称、App版本号、App Build版本号、Documents目录地址、Cache目录、临时目录等

```
/**
 App显示名称

 @return NSString
 */
```
- +(NSString *)appDisplayName;

```
/**
 App版本号

 @return NSString
 */
```
- +(NSString *)appVersion;

```
/**
 App构建版本号

 @return NSString
 */
```
- +(NSString *)appBuildVersion;

```
/**
 沙盒Documents目录

 @return NSString
 */
```
- +(NSString *)documentsPath;

```
/**
 沙盒Cache目录

 @return NSString
 */
```
- +(NSString *)cachesPath;

```
/**
 沙盒临时目录

 @return NSString
 */
```
- +(NSString *)tmpPath;

```
/**
 沙盒Documents下的文件路径地址

 @param fileName 文件名
 @return NSString
 */
```
- +(NSString *)documentPathWithFileName:(NSString *)fileName;

##### NSString+HMEncryption
> 加密、解密: MD5、Base64

```
/**
 字符串MD5加密(32位 小写)

 @return NSString
 */
```
- -(NSString *)md5ForLower32Bate;

```
/**
 字符串MD5加密(32位 大写)

 @return NSString
 */
```
- -(NSString *)md5ForUpper32Bate;

```
/**
 字符串MD5加密(16位 大写)

 @return NSString
 */
```
- -(NSString *)md5ForUpper16Bate;

```
/**
 字符串MD5加密(16位 小写)

 @return NSString
 */
```
- -(NSString *)md5ForLower16Bate;

```
/**
 字符串Base64加密
 
 @return NSString
 */
```
- -(NSString *)base64Encode;

```
/**
 base64字符串解密
 
 @return NSString
 */
```
- -(NSString *)base64Decode;

##### NSString+HMHexData
> 16进制相关操作: 转NSData、格式化mac地址、规整mac地址及固件版本比较

```
/**
 转成NSData(only: 小米运动)

 @return NSData
 */
```
- -(NSData *)toDataForHexString;

```
/**
 格式化mac地址，ex: 00:00:00:00:00:00(only: 小米运动)

 @return NSString
 */
```
- -(NSString *)formatPeripheralMacAddress;

```
/**
 mac地址串，不包含任何其他符号, ex: 000000000000(only: 小米运动)

 @return NSString
 */
```
- -(NSString *)peripheralMacAddress;

```
/**
 比较固件版本(only: 小米运动)

 @param versionString 版本
 @return YES/NO
 */
```
- -(BOOL)isEqualToFirmwareVersion:(NSString *)versionString;

##### NSString+HMJudge
> 对字符串的各种判断

```
/**
 字符串是否为空(如果string==nil， 则返回YES)

 @param string 要判断的字符串
 @return YES ? 空 : 不为空
 */
```
- +(BOOL)isEmpty:(NSString *)string;

```
/**
 字符串是否为有效邮箱地址

 @return YES ? 是 : 不是
 */
```
- -(BOOL)isValidEmail;

```
/**
 字符串是否为整型

 @return YES ? 是 : 不是
 */
```
- -(BOOL)isPureInt;

```
/**
 字符串是否为浮点型

 @return YES ? 是 : 不是
 */
```
- -(BOOL)isPureFloat;

```
/**
 字符串是否只包含数字

 @return YES ? 是 : 不是
 */
```
- -(BOOL)isOnlyContainNumber;

```
/**
 字符串是否为有效URL地址

 @return YES ? 是 : 不是
 */
```
- -(BOOL)isValidURL;

##### NSString+HMURL
> URL地址类字符串编码

```
/**
 URL地址编码
 
 @return NSString
 */
```
- -(NSString *)encodeToPercentEscapeString;

```
/**
 URL地址解码
 
 @return NSString
 */
```
- -(NSString *)decodeFromPercentEscapeString;

##### NSString+IPAddress
> IP地址

```
/**
 IP地址

 @return IP地址
 */
```
- +(NSString *)ipAddress;

```
/**
 MAC地址

 @return NSString
 */
```
- +(NSString *)getMacAddress;

##### NSString+Pinyin
> 拼音

```
/**
 转拼音

 @return 拼音
 */
```
- -(NSString *)pinyin;

#### NSTimer
##### NSTimer+Blocks
> NSTimer 快捷回调

```
/**
 创建NSTimer

 @param inTimeInterval 时间
 @param target target
 @param inRepeats 是否重复
 @param inBlock 回调Block
 @return NSTimer
 */
```
- +(instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval
         target:(id)target
        repeats:(BOOL)inRepeats
          block:(void (^)(NSTimer *timer))inBlock;

```
/**
 创建NSTimer

 @param inTimeInterval 时间
 @param target target
 @param inRepeats 是否重复
 @param inBlock 回调Block
 @return NSTimer
 */
```
- +(instancetype)timerWithTimeInterval:(NSTimeInterval)inTimeInterval
         target:(id)target
        repeats:(BOOL)inRepeats
          block:(void (^)(NSTimer *timer))inBlock;


### UIKit
#### UIApplication
##### UIApplication+Orientation
> 方向

```
/**
 更新方向(Only 小米运动)

 @param orientationMark UIInterfaceOrientationMask
 */
```
- -(void)updateOrientationMark:(UIInterfaceOrientationMask)orientationMark;

```
/**
 获取方向(Only 小米运动)

 @return UIInterfaceOrientationMask
 */
```
- -(UIInterfaceOrientationMask)allowScreenOrientationMark;

#### UIButton
##### UIButton+EnlargeTouchArea
> 按钮点击范围调整

```
/**
 设置按钮点击边界

 @param edge CGFloat
 */
```
- -(void)setEnlargeEdge:(CGFloat)edge;

```
/**
 设置四个方向的边界

 @param top top
 @param right right
 @param bottom bottom
 @param left left
 */
```
- -(void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

##### UIButton+HMLocalizableFlips
> 强制翻转

```
/**
 强制翻转(注：1、此在国际化下对需要翻转但未翻转图片进行翻转；2、此方法在设置image后调用)
 */
```
- -(void)forceFlipForLocalizable;

```
/**
 文本对其
 */
```
- -(void)textAlignmentForLocalizable;

#### UIColor
##### UIColor+HMGenerate
> 颜色的各种生成方式

```
/**
 hex生成Color(alpha为1.0)

 @param hexString hex字符串
 @return UIColor
 */
```
- +(UIColor *)colorWithHEXString:(NSString *)hexString;

```
/**
 hex生成Color，带alpha设置

 @param hexString hex字符串
 @param alpha alpha(0.0-1.0)
 @return UIColor
 */
```
- +(UIColor *)colorWithHEXString:(NSString *)hexString Alpha:(CGFloat)alpha;

```
/**
 RGB模式生成UIColor(alpha为1.0)(自动为您除以255.0)

 @param red Red(0-255.0)
 @param green green(0-255.0)
 @param blue blue(0-255.0)
 @return UIColor
 */
```
- +(UIColor *)colorWithRGB:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue;

````
/**
 RGB模式生成UIColor, alpha可以自己设置(自动为您除以255.0)

 @param red Red(0-255.0)
 @param green green(0-255.0)
 @param blue blue(0-255.0)
 @param alpha alpha(0.0-1.0)
 @return UIColor
 */
​```
- +(UIColor *)colorWithRGB:(CGFloat)red Green:(CGFloat)green Blue:(CGFloat)blue Alpha:(CGFloat)alpha;

````
/**
 颜色组成

 @param color 颜色1
 @param color2 颜色2
 @param value 因子值
 @return UIColor
 */
```
- +(UIColor *)composeColor1:(UIColor *)color Color2:(UIColor *)color2 Factor:(CGFloat)value;

#### UIDevice
##### UIDevice+HMDeviceIdentifier
> 设备ID

```
/**
 设备ID(Only 小米运动)

 @return NSString
 */
```
- +(NSString *)uniqueDeviceIdentifier;

##### UIDevice+HMVersion
> 系统版本

```
/**
 获取当前系统版本

 @return NSString
 */
```
- +(NSString *)systemVersion;

```
/**
 当前系统是否低于指定系统

 @param version 指定系统版本号

 @return YES ？ 低于指定系统 ： 不低于指定系统
 */
```
- +(BOOL)systemVersionLessThanVersion:(NSString *)version;

```
/**
 当前系统是否等于指定系统

 @param version 指定系统版本号

 @return YES ？ 等于指定系统 ： 不等于指定系统
 */
```
- +(BOOL)systemVersionEqualToVersion:(NSString *)version;

```
/**
 当前系统是否高于指定系统

 @param version 指定系统版本号

 @return YES ？ 高于指定系统 ： 不高于指定系统
 */
```
- +(BOOL)systemVersionGreaterThanVersion:(NSString *)version;

##### UIDevice+Orientation
> 方向组

```
/**
 设置允许的屏幕方向组(Only 小米运动)

 @param orientationMask UIInterfaceOrientationMask
 */
```
- +(void)setInterfaceOrientationMask:(UIInterfaceOrientationMask)orientationMask;

```
/**
 设置强制的屏幕方向，必须在允许的方向组里(Only 小米运动)

 @param interfaceorientation UIInterfaceOrientation
 @return BOOL
 */
```
- +(BOOL)setUIInterfaceOrientation:(UIInterfaceOrientation)interfaceorientation;

##### UIDevice+Resolutions
> 分辨率

```
/**
 分辨率

 @return UIDeviceResolution
 */
```
- +(UIDeviceResolution)resolution;

```
/**
 机器名称(Only 华米健康) eg iPhone4,1

 @return NSString
 */
```
- +(NSString *)machineName;

```
/**
 获取设备用户界面类型(Only 华米健康) eg ios_phone or ios_pad

 @return NSString
 */
```
- +(NSString *)userInterfaceIdiom;

```
/**
 屏幕高度

 @return CGFloat
 */
```
- +(CGFloat)screenHeight;

```
/**
 屏幕宽度

 @return CGFloat
 */
```
- +(CGFloat)screenWidth;

```
/**
 设备屏幕缩放比

 @return CGFloat
 */
```
- +(CGFloat)screenScale;

```
/**
 是否3.5屏设备

 @return BOOL
 */
```
- +(BOOL)isPhone3_5InchDevice;

```
/**
 是否4.0屏设备

 @return BOOL
 */
```
- +(BOOL)isPhone4inchDevice;

```
/**
 是否4.7屏设备

 @return BOOL
 */
```
- +(BOOL)isPhone4_7InchDevice;

```
/**
 是否5.5屏设备

 @return BOOL
 */
```
- +(BOOL)isPhone5_5InchDevice;

#### UIImage
##### UIImage+AlphaTint
> UIImage 根据颜色改变图片颜色, 生成新的图片

```
/**
 change image color, keep gradient alpha info

 @return image with gradient alpha info
 */
```
- -(UIImage *)imageWithAlphaTint:(UIColor *)tintColor;

##### UIImage+Color
> 图片颜色

```
/**
 颜色生成图片

 @param color 颜色
 @param size 大小
 @return UIImage
 */
```
- +(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

​````
/**
 颜色生成图片(默认大小为1)

 @param color 颜色
 @return UIImage
 */
```
- +(UIImage *)imageWithColor:(UIColor *)color;

```
/**
 颜色填充图片

 @param tintColor 颜色
 @return UIImage
 */
```
- -(UIImage *)imageWithTintColor:(UIColor *)tintColor;

```
/**
 边框

 @param color 颜色
 @param size 大小
 @param width 宽度
 @return UIImage
 */
```
- -(UIImage *)imageWithPureColorBorder:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width;

```
/**
 圆图

 @param color 颜色
 @param size 大小
 @param width 宽度
 @return UIImage
 */
```
- -(UIImage *)circularImageWithPureColorBorder:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width;

##### UIImage+FixOrientation
> 图片方向

```
/**
 调整图片方向

 @return UIImage
 */
```
- -(UIImage *)fixOrientation;

##### UIImage+HMCorner
> 图片圆角，包含合并图片功能

```
/**
 圆

 @return UIImage
 */
```
- -(UIImage *)clipImageToCircle;

```
/**
 图片添加圆角
 
 @param radius 圆角半径
 
 @return UIImage
 */
```
- -(UIImage *)cornerRadius:(CGFloat)radius;

```
/**
 图片添加圆角半径和边框
 
 @param radius      圆角半径
 @param borderWidth 边框宽度，<=0 无边框
 @param borderColor 边框颜色
 
 @return UIImage
 */
```
- -(UIImage *)cornerRadius:(CGFloat)radius
         borderWidth:(CGFloat)borderWidth
         borderColor:(UIColor *)borderColor;

```
/**
 图片合并
 
 @param imageOne 图片1
 @param imageTwo 图片2
 @param imageMergeDirection 合并方向: 横向合并和纵向合并
 @return 合并后的Image
 */
```
- +(UIImage *)multipleImgaeMerge:(UIImage *)imageOne toImage:(UIImage *)imageTwo direction:(HMImageMergeDirection)imageMergeDirection;

##### UIImage+HMData
> 图片转NSData

```
/**
 转NSData

 @return NSData
 */
```
- -(NSData *)toImageData;

```
/**
 压缩NSData

 @param imageData NSData
 @param maxBytes maxBytes
 @return NSData
 */
```
- +(NSData *)compressImageWithImageData:(NSData *)imageData maxBytes:(CGFloat)maxBytes;

##### UIImage+HMScale
> 图片缩放操作

```
/**
 图片缩放
 
 @param scaleSize 缩放比例
 @return UIImage
 */
```
- -(UIImage *)scaleImageToScale:(float)scaleSize;

##### UIImage+ImageEffects
> 图片效果

```
/**
 亮光效果

 @return UIImage
 */
```
- -(UIImage *)applyLightEffect;

````
/**
 强光效果

 @return UIImage
 */
​```
- -(UIImage *)applyExtraLightEffect;

​```
/**
 暗色效果

 @return UIImage
 */
​```
- -(UIImage *)applyDarkEffect;

​```
/**
 渲染效果

 @param tintColor 颜色
 @return UIImage
 */
​```
- -(UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

​```
/**
 应用效果
 
 @param blurRadius 模糊半径
 @param tintColor 渲染颜色
 @param saturationDeltaFactor 色彩饱和度
 @param maskImage 遮罩图片
 @return UIImage
 */
​```
- -(UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

#### UIScrollView
##### UIScrollView+EdgePanGesture
> 对于一个横向滚动的UIScrollView，如果要让其在滚动到最左（scrollOffset.x == 0）的时候支持侧滑返回上个页面，就调用enableEdgePanGesture。

​```
/**
 开启
 */
​```
- -(void)enableEdgePanGesture;

​```
/**
 关闭
 */
​```
- -(void)disableEdgePanGesture;

#### UITextView
##### UITextView+Placeholder
> UITextView加Placeholder

​```
/**
 label
 */
​```
- @property (nonatomic, readonly) UILabel *placeholderLabel;

​```
/**
 文字
 */
​```
- @property (nonatomic, strong) NSString *placeholder;

​```
/**
 富文本
 */
​```
- @property (nonatomic, strong) NSAttributedString *attributedPlaceholder;

​```
/**
 颜色
 */
​```
- @property (nonatomic, strong) UIColor *placeholderColor;

​```
/**
 默认颜色

 @return UIColor
 */
​```
- +(UIColor *)defaultPlaceholderColor;

#### UIView
##### UIView+ColorOfPoint
> UIView上的点获取颜色值

​```
/**
 根据点获取颜色值(Only 小米运动)

 @param point 点
 @return UIColor
 */
​```
- -(UIColor *)colorOfPoint:(CGPoint)point;

##### UIView+HMConvertToImage
> UIView转UIImage

​```
/**
 转Image

 @return UIImage
 */
​```
- -(UIImage *)toImage;

​```
/**
 转Image

 @param frame frame
 @return UIImage
 */
​```
- -(UIImage *)toImageWithFrame:(CGRect)frame;

​```
/**
 父View转Image

 @return UIImage
 */
​```
- -(UIImage *)toImageFromSuperView;

​```
/**
 公类(将View转Image)

 @param view view
 @param frame frame
 @return UIImage
 */
​```
- +(UIImage *)toImageFromView:(UIView *)view withFrame:(CGRect)frame;

​```
/**
 将ScrollView转Image

 @return UIImage
 */
​```
- -(UIImage *)toImageFromScrollView;

##### UIView+HMXib
> UIView添加xib和subView

​```
/**
 添加xib(默认是无边距添加)

 @param nibName 名称
 @param owner 属于者
 @return UIView
 */
​```
- -(UIView *)addNibNamed:(NSString *)nibName owner:(id)owner;

​```
/**
 添加xib(默认是无边距添加)

 @param nibName 名称
 @return UIView
 */
​```
- -(UIView *)addNibNamed:(NSString *)nibName;

​```
/**
 添加子View(默认是无边距添加)

 @param view view
 @return UIView
 */
​```
- -(UIView *)addSubviewToFillContent:(UIView *)view;

##### UIView+Size
> UIView的frame
​```
size
​```
- @property (nonatomic, assign) CGSize size;

​```
left
​```
- @property (nonatomic, assign) CGFloat left;

​```
right
​```
- @property (nonatomic, assign) CGFloat right;

​```
top
​```
- @property (nonatomic, assign) CGFloat top;

​```
bottom
​```
- @property (nonatomic, assign) CGFloat bottom;

​```
centerX
​```
- @property (nonatomic, assign) CGFloat centerX;

​```
centerY
​```
- @property (nonatomic, assign) CGFloat centerY;

​```
width
​```
- @property (nonatomic, assign) CGFloat width;

​```
height
​```
- @property (nonatomic, assign) CGFloat height;

#### UIWindow
##### UIWindow+Tools
> Top Winow Top ViewController

​```
/**
 顶部window(Only 小米运动)

 @return UIWindow
 */
​```
- +(UIWindow *)topNormalLevelWindow;

​```
/**
 UIViewController(Only 小米运动)

 @return UIViewController
 */
​```
- +(UIViewController *)topMostViewController;
````