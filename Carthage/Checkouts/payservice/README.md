# HMPayKit


## Requirements
注意添加下列信息:

### 1. 白名单
        <key>LSApplicationQueriesSchemes</key>
        <array>
            <string>alipay</string>
            <string>weixin</string>
        </array>
        <key>NSAppTransportSecurity</key>
        <dict>
            <key>NSAllowsArbitraryLoads</key>
            <true/>
        </dict>

###2. URLScheme (info.plist)

**eg.**

        <key>CFBundleURLTypes</key>
        <array>
            <dict>
                <key>CFBundleTypeRole</key>
                <string>Editor</string>
                <key>CFBundleURLName</key>
                <string>alipay</string>
                <key>CFBundleURLSchemes</key>
                <array>
                    <string>HMPayKitExample</string>
                </array>
            </dict>
            <dict>
                <key>CFBundleTypeRole</key>
                <string>Editor</string>
                <key>CFBundleURLName</key>
                <string>weixin</string>
                <key>CFBundleURLSchemes</key>
                <array>
                    <string>wxd930ea5d5a258f4f</string>
                </array>
            </dict>
        </array>

### 3. 加载微信.a库

        other link flag 需要 -all_load


## Q&A

####1.报错信息一

         Undefined symbols for architecture arm64: “_OBJC_CLASS_$报错信息
         target Build Settings -> Other linker flags -> Add $(inherited)

####2.
建议使用carthage方式
注意：如果直接Linked Framework方式失败，请使用Embedded Binaries方式.

## Installation

HMPayKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HMPayKit'
```

## Author

huami-dev, luoliangliang@huami.com

## License

HMPayKit is available under the MIT license. See the LICENSE file for more info.


