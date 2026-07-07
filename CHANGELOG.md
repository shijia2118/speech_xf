## 2.0.1
* 调整 Dart SDK 版本约束写法，兼容 pub.dev 发布校验规则。

## 2.0.0
* 升级 Flutter / Dart 约束，适配 Flutter 3.44.2。
* Android 端升级 Gradle / AGP / Kotlin 配置，迁移 example 工程到新版 Gradle Kotlin DSL。
* Android 端修复旧版 `FlutterMain` API 不兼容问题，改用新版 Flutter embedding 的资源查找方式。
* Android example 补充 v2 embedding 探测文件，修复被误判为 Android v1 embedding 的构建问题。
* IOS 端升级最低支持版本到 13.0，并适配 Flutter 3.44.2 的 iOS 构建配置。
* IOS 端修复非 modular header 导致的模拟器构建问题。
* example 移除 `adaptive_dialog` 依赖，改用 Flutter 原生弹窗，避免间接依赖阻塞 Android 构建。
* 更新 example 测试与 lint 规则，修复 Flutter 3.44.2 下的静态检查问题。

## 1.3.0
* IOS端修改`type`字段名称为`speechType`.

## 1.2.3
* 修复一些已知问题

## 1.2.2
* IOS修复cup架构问题

## 1.2.1
* IOS修复cup架构问题

## 1.2.0
* IOS修复一些已知问题

## 1.1.0
* 页面销毁时,移除监听

## 1.0.2
* 修复一些已知问题

## 1.0.1
* 新增声音变化回调

## 1.0.0
**破坏性版本**
* 1.修复一些已知问题；
* 2.优化监听回调函数结构

## 0.0.6
* 修复一些已知的问题

## 0.0.5
* 新增语音合成模块

## 0.0.4
* 更新README.md

## 0.0.1
* TODO: Describe initial release.
