
Pod::Spec.new do |s|
 gerritURL           = "ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/app_extension"

  s.name             = 'HMExtensionKit'
  s.version          = '0.3.2'
  s.summary          = 'iOS Extensions Kit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This pod include SiriKit, Today Extesion, and 3DTouch. You can select what you need. 
All of them are separated sub-modules, independent with each other.
                       DESC

  s.homepage         = 'https://internal.smartdevices.com.cn:8080/#/admin/projects/apps/ios/libs/app_extension'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'jiangyang' => 'jiangyang@huami.com' }
  s.source           = { :git => gerritURL, :tag => s.version.to_s }

  s.frameworks = 'Foundation', 'UIKit'
  #s.dependency 'ReactiveCocoa', '~> 2.5'
  s.ios.deployment_target = '8.0'

  
  # s.resource_bundles = {
  #   'ExtensionKit' => ['ExtensionKit/Assets/*.png']
  # }

  s.subspec 'Siri' do |ss|
    ss.frameworks = 'Intents'
    ss.source_files = 'HMExtensionKit/Classes/Siri/**/*'
  end

  s.subspec 'Today' do |ss|
    ss.frameworks = 'NotificationCenter'
    ss.source_files = 'HMExtensionKit/Classes/Today/**/*'
  end

  s.subspec '3DTouch' do |ss|
    ss.source_files = 'HMExtensionKit/Classes/3DTouch/**/*'
  end
end
