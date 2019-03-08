#
# Be sure to run `pod lib lint HMCrashReport.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMCrashReport'
  s.version          = '1.0.0'
  s.summary          = '华米崩溃收集'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    华米崩溃收集服务，当前版本还无法全自动进行崩溃查看。需要手动下载崩溃文件进行本地化解析。
                       DESC

  s.homepage         = 'https://internal.smartdevices.com.cn:8080/#/admin/projects/apps/ios/libs/crash_report'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BigNerdCoding' => 'bignerdcoding@gmail.com' }
  s.source           = { :git => 'ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/crash_report', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HMCrashReport/HMCrashReport/*'
  s.public_header_files = 'HMCrashReport/HMCrashReport/HMCrashReport.h', 'HMCrashReport/HMCrashReport/HMCrashReportService.h'
  
  s.dependency 'KSCrash', '~> 1.15.18'
end
