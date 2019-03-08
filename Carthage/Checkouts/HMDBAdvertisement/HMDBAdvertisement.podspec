#
# Be sure to run `pod lib lint HMDBAdvertisement.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMDBAdvertisement'
  s.version          = '0.3.2'
  s.summary          = 'A short description of HMDBAdvertisement.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/BigNerdCoding/HMDBAdvertisement'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'BigNerdCoding' => 'bignerdcoding@gmail.com' }
  s.source           = { :git => 'ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/HMDBAdvertisement', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.subspec 'Persistance' do |sp|
    sp.source_files = 'HMDBAdvertisement/Persistance/**/*'
    sp.public_header_files = 'HMDBAdvertisement/Persistance/HMDBAdvertisementConfig.h'
    sp.dependency 'CTPersistance', '~> 181'
  end

  s.subspec 'Services' do |sp|
    sp.source_files = 'HMDBAdvertisement/Services/**/*'
    sp.private_header_files = 'HMDBAdvertisement/Services/ModelCategory/**/*.h'
    sp.dependency 'HMDBAdvertisement/Persistance'
  end

  s.default_subspec = 'Services'
  # s.resource_bundles = {
  #   'HMDBAdvertisement' => ['HMDBAdvertisement/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
