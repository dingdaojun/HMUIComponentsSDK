2018-1-11  2.3.0
  增加手机号验证接口
2017-12-21  2.2.5
  账号SDK中NSError分类中增加错请求的URLResponse 和 IP
  邮箱手机号请求增加IP属性
  
2017-12-21  2.2.4
  HMAccountConfig中增加配置接口，支持所有请求添加自定义HEADER
  
2017-12-20  2.2.3
  邮箱注册/重置密码增加对图片验证码支持
  
2017-11-24  2.2.1
  refreshApptokenEventHandler 增加cache机制，防止频繁接口请求
   
2017-11-20  2.2.0
   增加错误码113/114/115,NSError增加nextAction字段

2017-11-01  2.1.1
	支持Carthage

2017-11-01  2.1.0
  1、Line登录支持
  2、解决不同线程之间调用获取apptoken导致的crash

2017-10-24  2.0.0
增加：
  1、邮箱账号相关业务接口
  2、手机号相关业务接口
  3、google登录支持
  4、增加获取当前用户登录的手机号接口：getPhoneNumberWithEventHandler
修改：
  一、服务器调整
 	 1、账号使用统一域名
    	（1）登录接口变更，由原来的/v1/client/login变更为/v2/client/login,去掉search接口（三方登录，邮箱/手机号对账号系统来说算是第三方登录）
  	 2、参数变更,增加country_code参数(必填项)
     	 (1)登录接口loginWithPlatform:(HMIDLoginPlatForm)platForm ...（小米运动升级接口不变）
		（2）绑定接口bindWithPlatForm:(HMIDLoginPlatForm)platForm ...
  二、API变更
     1、登录绑定接口，增加必填参数region（国家区域码）
     	 (1)登录接口loginWithPlatform:(HMIDLoginPlatForm)platForm ...（小米运动升级接口不变）
		（2）绑定接口bindWithPlatForm:(HMIDLoginPlatForm)platForm ...
     2、token刷新更新策略完善
       （1）判断本地有没有logintoken，没有则返回错误信息和本地的apptoken信息，否则（2）
	   （2）调用刷新apptoken接口，成功返回apptoken信息，失败返回返回错误信息和本地的apptoken信息
	 3、返回数据结构变更
        (1)HMIDRegistItem 属性region， 由原有的枚举换为NSInteger，为了支持后续服务器增加国家
