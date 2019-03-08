#
# Be sure to run `pod lib lint HMDBFirmwareUpgrade.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMDBFirmwareUpgrade'
  s.version          = '0.7.0'
  s.summary          = 'A short description of HMDBFirmwareUpgrade.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
    用于固件版本升级提醒的类库，基于 SQLite 构建
                       DESC

  s.homepage         = 'https://internal.smartdevices.com.cn:8080/#/admin/projects/apps/ios/libs/dfu_db'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BigNerdCoding' => 'wumingliang@huami.com' }
  s.source           = { :git => 'ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/dfu_db', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/bignerdcoding'

  s.ios.deployment_target = '8.0'

  s.default_subspec = 'Service'

  s.subspec 'Database' do |ss|
    ss.source_files = 'HMDBFirmwareUpgrade/Classes/Database/**/*.{h,m}'
    ss.public_header_files = 'HMDBFirmwareUpgrade/Classes/Database/HMDBFirmwareUpgradeBaseConfig.h'
    ss.dependency 'CTPersistance', '~> 181'
  end

  s.subspec 'Service' do |ss|
    ss.source_files = 'HMDBFirmwareUpgrade/Classes/Service/**/*.{h,m}'
    ss.private_header_files = 'HMDBFirmwareUpgrade/Classes/Service/Model/*.h'
    ss.dependency 'HMDBFirmwareUpgrade/Database'
  end
  
end
