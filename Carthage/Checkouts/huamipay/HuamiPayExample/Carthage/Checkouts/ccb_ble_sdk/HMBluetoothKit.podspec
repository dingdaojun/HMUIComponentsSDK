Pod::Spec.new do |s|
  s.name         = "HMBluetoothKit"
  s.version      = "0.0.1"
  s.summary      = "huami bluetooth kit."
  s.description  = <<-DESC
蓝牙框架脑图: http://naotu.baidu.com/file/f98676f5e02ad0903022caa030070b58?token=030aee8b5119e071
                   DESC

  s.homepage     = "https://internal.smartdevices.com.cn:8080/#/admin/projects/apps/ios/libs/ccb_ble_sdk"
  s.license      = "MIT"
  s.authors      = { "yubiao" => "yubiao@huami.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/ccb_ble_sdk", :branch => "swiftBle"}
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }
  s.module_map = 'Framework/HMBluetoothKit.modulemap'
  
  s.subspec 'LEExtension' do |extension|
    extension.public_header_files = 'HMBluetoothKit/LEExtension/*'
    extension.source_files = 'HMBluetoothKit/LEExtension/*'
  end

  s.subspec 'LECore' do |core|
    core.dependency 'HMBluetoothKit/LEExtension'
    core.source_files = 'HMBluetoothKit/LECore/*'
    core.public_header_files = 'HMBluetoothKit/LECore/*'
  end
  s.subspec 'LEService' do |service|
    service.dependency 'HMBluetoothKit/LECore'
    service.source_files = 'HMBluetoothKit/LEService/*'
    service.public_header_files = 'HMBluetoothKit/LEService/*'
    service.dependency 'CryptoSwift', '~> 0.10.0'
  end
  s.subspec 'LEProfile' do |profile|
    profile.dependency 'HMBluetoothKit/LEService'
    profile.public_header_files = 'HMBluetoothKit/LEProfile/*'
    profile.source_files = 'HMBluetoothKit/LEProfile/*'
  end
    
  s.source_files = 'HMBluetoothKit/HMBluetoothKit.h'
  s.default_subspec = 'LEProfile'
end
