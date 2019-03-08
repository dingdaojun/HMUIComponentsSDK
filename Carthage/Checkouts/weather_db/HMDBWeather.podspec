#
# Be sure to run `pod lib lint HMDBWeather.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMDBWeather'
  s.version          = '0.5.6'
  s.summary          = 'A short description of HMDBWeather.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                         用于天气预报的持久化类库，基于 SQLite 构建
                       DESC

  s.homepage         = 'https://github.com/BigNerdCoding/HMDBWeather'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BigNerdCoding' => 'wumingliang@gmail.com' }
  s.source           = { :git => 'ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/weather_db', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.subspec 'Database' do |ss|
    ss.source_files = 'HMDBWeather/Classes/Database/**/*.{h,m}'
    ss.public_header_files = 'HMDBWeather/Classes/Database/HMDBWeatherBaseConfig.h'
    ss.dependency 'CTPersistance', '~> 181'
  end

  s.subspec 'Service' do |ss|
    ss.source_files = 'HMDBWeather/Classes/Service/**/*.{h,m}'
    ss.private_header_files = 'HMDBWeather/Classes/Service/Model/**/*.h'
    ss.dependency 'HMDBWeather/Database'
  end

  
  # s.resource_bundles = {
  #   'HMDBWeather' => ['HMDBWeather/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
