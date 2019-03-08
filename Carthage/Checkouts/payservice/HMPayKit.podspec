#
# Be sure to run `pod lib lint HMPayKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMPayKit'
  s.version          = '0.1.7'
  s.summary          = '华米科技支付lib.'
  s.description      = <<-DESC
包含支付宝，微信等支付方式.
                       DESC

  s.homepage         = 'https://internal.smartdevices.com.cn:8080/#/admin/projects/apps/ios/libs/payservice'
  s.license          = { :type => 'MIT' }
  s.author           = { 'huami-dev' => 'luoliangliang@huami.com' }
  s.source           = { :git => 'ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/payservice', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  s.public_header_files = 'HMPayKit/Core/*.h','HMPayKit/Platforms/aliPay/*.h','HMPayKit/Services/*.h'
  s.source_files = 'HMPayKit/Core/*.{h,m,mm}','HMPayKit/Platforms/aliPay/*.{h,m,mm}','HMPayKit/Services/*.{h,m,mm}'

  s.libraries = 'z', 'sqlite3.0', 'c++'
  s.frameworks = 
                'UIKit', 
                'Foundation', 
                'MobileCoreServices', 
                'SystemConfiguration', 
                'CoreGraphics', 
                'QuartzCore',
                'Security',
                'CoreTelephony',
                'CoreText',
                'CoreMotion',
                'CFNetWork'

  s.vendored_frameworks = 'HMPayKit/Platforms/aliPay/AlipaySDK.framework'
  s.resources = ['HMPayKit/Platforms/aliPay/*.{bundle}']
  s.dependency 'WechatOpenSDK'
end
