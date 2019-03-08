#
# Be sure to run `pod lib lint HMLog.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMLog'
  s.version          = '0.5.6'
  s.summary          = 'iOS prviate logging library for Huami'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is a private logging library for Huami Inc.
                       DESC

  s.homepage         = 'https://internal.smartdevices.com.cn:8080/#/admin/projects/apps/ios/libs/log'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = 'MIT'
  s.author           = { 'lixian@huami.com' => 'lixian@huami.com' }
  s.source           = { :git => 'ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/log', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files          = 'HMLog/*.{h,m}', 'HMLog/**/*.{h,m}'
  s.resource              = "HMLog/Loggers/Web/HMWebLogger.bundle"

  s.frameworks            = 'UIKit', 'MobileCoreServices', 'CFNetwork', 'SystemConfiguration'
  s.library               = 'sqlite3', 'z', 'xml2'
  s.vendored_frameworks = 'Carthage/Build/iOS/GCDWebServers.framework'
end
