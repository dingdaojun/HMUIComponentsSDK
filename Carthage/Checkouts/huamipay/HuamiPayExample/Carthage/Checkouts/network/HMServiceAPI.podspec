Pod::Spec.new do |s|
  s.name     = 'HMServiceAPI'
  s.version  = '1.9.9'
  s.author   =  { 'lixian' => 'lixian@huami.com' }
  s.license  = 'MIT'
  s.homepage = 'https://internal.smartdevices.com.cn:8080/#/admin/projects/apps/ios/libs/network'
  s.summary  = '华米网络库'
  s.source           = { :git => 'ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/network', :commit => '791cb3f58ad3d48807647568189793f104873dfa' }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.default_subspec = 'HMNetworkLayer'
  
  s.subspec 'HMNetworkLayer' do |ss|
    ss.dependency 'AFNetworking'

    ss.source_files = 'Demo/HMNetworkLayer/*.{h,m}'
  end

  s.subspec 'HMService' do |ss|
	  ss.dependency 'HMServiceAPI/HMNetworkLayer'

    ss.source_files = 'Demo/HMService/*.{h,m}', 'Demo/HMService/private/*.{h,m}', 'Demo/HMService/Helpers/*.{h,m}'
    ss.public_header_files = 'Demo/HMService/*.h', 'Demo/HMService/Helpers/*.h'
  end

  s.subspec 'MIFitService' do |ss|
    ss.dependency 'HMCategory'
    ss.dependency 'HMServiceAPI/HMService'

    ss.source_files = 'Demo/HMService/MIFitService/*.{h,m}'
  end

  s.subspec 'AmazfitWatchService' do |ss|
    ss.dependency 'HMServiceAPI/HMService'

    ss.source_files = 'Demo/HMService/AmazfitWatchService/*.{h,m}'
  end

  s.subspec 'SmartAssistantService' do |ss|
    ss.dependency 'HMServiceAPI/HMService'

    ss.source_files = 'Demo/HMService/SmartAssistantService/*.{h,m}'
  end

  s.subspec 'TrainingService' do |ss|
    ss.dependency 'HMServiceAPI/HMService'

    ss.source_files = 'Demo/HMService/TrainingService/*.{h,m}'
  end

  s.subspec 'RunService' do |ss|
    ss.dependency 'objc-geohash'
    ss.dependency 'HMServiceAPI/HMService'

    ss.source_files = 'Demo/HMService/RunService/*.{h,m}', 'Demo/HMService/RunService/RunServiceDataItem/*.{h,m}', 'Demo/HMService/RunService/NSString/*.{h,m}'
  end

  s.subspec 'WalletService' do |ss|
    ss.dependency 'HMServiceAPI/HMService'

    ss.source_files = 'Demo/HMService/WalletService/*.{h,m}'
  end

  s.subspec 'WeatherService' do |ss|
    ss.dependency 'HMServiceAPI/HMService'

    ss.source_files = 'Demo/HMService/WeatherService/*.{h,m}'
  end

end
