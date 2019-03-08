#
# Be sure to run `pod lib lint HMStatistics.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMStatistics'
  s.version          = '1.4.6'
  s.summary          = 'A short description of HMStatistics.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/BigNerdCoding/HMStatistics'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BigNerdCoding' => 'bignerdcoding@gmail.com' }
  s.source           = { :git => 'ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/statistics', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.subspec 'AnonymousDataBase' do |sp|
    sp.source_files = 'HMStatistics/AnonymousDataBase/**/*'
    sp.private_header_files = 'HMStatistics/AnonymousDataBase/**/*.h'
    sp.dependency 'CTPersistance', '~> 181'
  end

  s.subspec 'NamedDataBase' do |sp|
    sp.source_files = 'HMStatistics/NamedDataBase/**/*'
    sp.private_header_files = 'HMStatistics/NamedDataBase/**/*.h'
    sp.dependency 'CTPersistance', '~> 181'
  end

  s.subspec 'Statistics' do |sp|
    sp.source_files = 'HMStatistics/Statistics/**/*'
    sp.public_header_files = 'HMStatistics/Statistics/HMStatisticsConfig.h', 'HMStatistics/Statistics/HMStatisticsLog.h','HMStatistics/Statistics/HMStatisticsLog+BothChannel.h','HMStatistics/Statistics/HMStatisticsPageAutoTracker.h'
    sp.dependency 'HMStatistics/NamedDataBase'
    sp.dependency 'HMStatistics/AnonymousDataBase'
  end

  s.default_subspec = 'Statistics'

  s.frameworks = 'UIKit', 'SystemConfiguration', 'CoreTelephony'
end
