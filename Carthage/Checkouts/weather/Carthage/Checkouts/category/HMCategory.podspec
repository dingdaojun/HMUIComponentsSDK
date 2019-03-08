#
# Be sure to run `pod lib lint HMCategory.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HMCategory'
  s.version          = '0.4.1'
  s.summary          = 'Huami iOS development based on extension category library.'

  s.description      = <<-DESC
1. FoundationKit Category Library for Developer.
2. UIKit Category Library For Developer.
3. Default Category library is HMCategoryKit.
4. We also provide category which connected with bussiness AppCategory, for example: HMCategoryMifitKit, HMCategoryHealthKit.
                       DESC

  s.homepage         = 'https://internal.smartdevices.com.cn:8080/#/admin/projects/apps/ios/libs/category'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'congni' => 'yubiao@huami.com' }
  s.source           = { :git => 'ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/category', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'

  # 默认配置基础库，具体根据项目，引入HMCategoryMifitKit或者HMCategoryHealthKit
  s.default_subspec = 'HMCategoryKit'

  s.subspec 'HMCategoryKit' do |ss|
    ss.source_files = 'HMCategoryKit/HMCategoryKit.h'

    ss.subspec 'FoundationKit' do |foundation|
        foundation.subspec 'NSArray' do |array|
            array.source_files = 'HMCategoryKit/FoundationKit/NSArray/*'
        end
        foundation.subspec 'NSData' do |data|
            data.source_files = 'HMCategoryKit/FoundationKit/NSData/*'
        end
        foundation.subspec 'NSDate' do |date|
            date.source_files = 'HMCategoryKit/FoundationKit/NSDate/*'
        end
        foundation.subspec 'NSDictionary' do |dictionary|
            dictionary.source_files = 'HMCategoryKit/FoundationKit/NSDictionary/*'
        end
        foundation.subspec 'NSLocal' do |local|
            local.source_files = 'HMCategoryKit/FoundationKit/NSLocal/*'
        end
        foundation.subspec 'NSNotificationCenter' do |center|
            center.source_files = 'HMCategoryKit/FoundationKit/NSNotificationCenter/*'
        end
        foundation.subspec 'NSObject' do |object|
            object.source_files = 'HMCategoryKit/FoundationKit/NSObject/*'
        end
        foundation.subspec 'NSString' do |string|
            string.dependency 'HMCategory/HMCategoryKit/FoundationKit/NSDate'
            string.source_files = 'HMCategoryKit/FoundationKit/NSString/*'
        end
        foundation.subspec 'NSTimer' do |timer|
            timer.source_files = 'HMCategoryKit/FoundationKit/NSTimer/*'
        end
    end
    ss.subspec 'UIKit' do |uiKit|
        uiKit.subspec 'UIApplication' do |application|
            application.source_files = 'HMCategoryKit/UIKit/UIApplication/*'
        end
        uiKit.subspec 'UIButton' do |button|
            button.source_files = 'HMCategoryKit/UIKit/UIButton/*'
        end
        uiKit.subspec 'UIImageView' do |imageView|
            imageView.source_files = 'HMCategoryKit/UIKit/UIImageView/*'
        end 
        uiKit.subspec 'UILabel' do |label|
            label.source_files = 'HMCategoryKit/UIKit/UILabel/*'
        end
        uiKit.subspec 'UITextField' do |textField|
            textField.source_files = 'HMCategoryKit/UIKit/UITextField/*'
        end
        uiKit.subspec 'UIColor' do |color|
            color.source_files = 'HMCategoryKit/UIKit/UIColor/*'
        end
        uiKit.subspec 'UIDevice' do |device|
            device.dependency 'HMCategory/HMCategoryKit/UIKit/UIApplication'
            device.source_files = 'HMCategoryKit/UIKit/UIDevice/*'
        end
        uiKit.subspec 'UIImage' do |image|
            image.source_files = 'HMCategoryKit/UIKit/UIImage/*'
        end
        uiKit.subspec 'UIScrollView' do |scrollView|
            scrollView.source_files = 'HMCategoryKit/UIKit/UIScrollView/*'
        end
        uiKit.subspec 'UITextView' do |textView|
            textView.source_files = 'HMCategoryKit/UIKit/UITextView/*'
        end
        uiKit.subspec 'UIView' do |view|
            view.source_files = 'HMCategoryKit/UIKit/UIView/*'
        end
        uiKit.subspec 'UIWindow' do |window|
            window.source_files = 'HMCategoryKit/UIKit/UIWindow/*'
        end
    end
  end

  s.subspec 'HMCategoryMifitKit' do |ss|
      ss.dependency 'HMCategory/HMCategoryKit'
      ss.source_files = 'HMCategoryMifitKit'
  end

  s.subspec 'HMCategoryHealthKit' do |ss|
      ss.source_files = 'HMCategoryHealthKit'
  end

  s.frameworks = 'UIKit', 'Foundation'
end
