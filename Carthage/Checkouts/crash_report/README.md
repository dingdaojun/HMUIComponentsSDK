# HMCrashReport

华米内部 Crash 收集服务，基于 KSCrash 二次开发。当前主要开启的 Crash 监控器为：KSCrashMonitorTypeProductionSafeMinimal ，Crash 统计信息采用 JSON 文件格式进行存储。另外，Crash 文件的基本的本地化解析脚本为 KSCrash_JSON.py 。该脚本代码能够完成除系统只带的 Framework Crash 反解。

## 安装

Cocoapods 安装方式：

```ruby
pod 'HMCrashReport'
```

Carthage 安装：

```
git "ssh://internal.smartdevices.com.cn:29418/apps/ios/libs/crash_report" == 0.1.0
```

## KSCrash 代码架构

整体代码设计架构与顾总之前讨论是常说的架构很像：

+-------------------------------------------------------------+
|                         Installation                        |
|        +----------------------------------------------------+
|        |                  KSCrash                           |
|    +--------------------------------------------------------+
|    | Crash Reporting | Crash Recording | Crash Report Store |
+----+-----------------+-----------------+--------------------+
|       Filters        |     Monitors    |
+----------------------+-----------------+

### Installation

框架的主接口，理论上我们可以直接使用该层 API。当然我们也可以通过继承模式进行自定义实现。

### KSCrash

相当于一个 Manager 或者 Controller ，负责底层各功能模块的管理工作。里面涉及到底层模块的各种配置管理，在自定义场景下，我们可以通过 Custom Installtion 对其进行自定义配置，将其透明化隐藏起来。



### Crash Report Store

Crash 文件的持久化模块，提供最基本的 Crash 文件读写功能。主要代码入口在：KSCrashReportStore.h



### Crash Recording

该模块通过 Monitors 对异常进行监控，并且通过异步方式记录最终的 Crash 保存到持久化模块。

### Crash Reporting

Crash 文件的上报处理模块，框架内部已经配套提供了与 Installation 对应标准方式。另外，该模块构建于 KSCrashReportFilter 协议之上，为自定义提供了多种可能性。

### Monitors

主要是各种类型异常的监控器，所有的监控器开启状态可以在 KSCrash 中进行配置。不过我建议前期只要抓取集中常见错误：

1. Mach Exception
2. Signal
3. NSException
4. C++ Exception

## 解析脚本
下载对应文件，然后运行 

```python
python3 KSCrash_JSON.py $input_crash $input_dSYM $output
```
## Author

BigNerdCoding, bignerdcoding@gmail.com

## License

HMCrashReport is available under the MIT license. See the LICENSE file for more info.
