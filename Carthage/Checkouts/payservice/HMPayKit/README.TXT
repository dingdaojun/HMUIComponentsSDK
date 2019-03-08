注意添加下列信息:

1. 白名单
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

2. URLScheme (info.plist)

eg.

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

3. 加载微信.a库

other link flag需要 -all_load
