# Claude 记忆存储

## 会话信息
- 日期: 2025-11-28
- 项目路径: /Users/admin/Documents/github/DTBKit
- 当前分支: main

## 用户偏好
- 语言: 中文
- 记忆存储位置: CLAUDE.md
- 文件修改规则: 除非明确要求，不要修改除 CLAUDE.md 以外的项目中已有的 md 文件
- Swift 开发规范: 遵循 MOON Swift 最佳实践

## Swift 开发最佳实践 (简化版)

### 项目管理
- 使用 XcodeGen (project.yml) + CocoaPods
- 不使用 Storyboard/xib/Scene Delegate/SPM
- 最低支持版本与 Podfile/project.yml 保持一致
- 依赖版本号固定，不使用 `~>` 符号

### 代码规范
- 架构: MVVM 模式，每个 ViewController 对应 View 和 ViewModel
- 布局: 优先 AutoLayout，统一命名容器为 `box`
- 对象初始化: 使用 `private lazy var`
- 重构时彻底删除旧代码，不保留未调用方法

### Git 提交
#### 格式要求
- 模板: `[type] 描述 by CCR.`
- 类型: feat/fix/improve/docs/style/perf/test
- 首行 <72 字符
- 提交前保存上下文到 CLAUDE.md
#### 输出规则
- 直接输出 commit 信息，无引导文本
- 禁止 AI 生成标识 (Written by Claude 等)
- 禁止签名行 (Signed-off-by 等)
- 正文无 emoji、英文中括号
#### 示例
[feat] 添加用户登录功能 by CCR.
[fix] 修复内存泄漏问题 by CCR.

### DTBKit 项目适配
- 当前使用 XcodeGen + CocoaPods ✓
- iOS 11.0+ 最低支持 ✓
- 已有完善的链式 API 和命名空间设计 ✓
- 需要注意与现有 Provider 系统架构保持一致

## 项目上下文
- 这是一个 git 仓库
- 最近的提交包括:
  - d5f2def refactor for providers
  - 747681a daily
  - 3e933db fix with base view
  - e62beed final button nearly done!
  - 698442d update change by tarot

## DTBKit 项目分析

### 项目简介
DTBKit 是一个 Swift iOS 框架，专注于**命名空间隔离**和**链式 API 设计**的个人开发工具包。主要目标：
- 命名空间隔离：在不污染全局命名空间的情况下扩展现有类
- 链式 API：支持流畅的方法链语法进行对象配置
- 代码复用：便于业务代码在不同项目间无痛迁移
- 最佳实践：展示 iOS 开发模式和实践

### 核心架构
1. **命名空间系统**：DTB 枚举作为静态命名空间，Kitable/Structable 协议
2. **链式系统**：Chainable 协议实现方法链
3. **提供者系统**：依赖注入模式，支持可定制行为

### 技术栈
- Swift 5.0+，iOS 11.0+
- UIKit, Foundation 框架
- CocoaPods, Swift Package Manager
- 依赖：lottie-ios, Toast-Swift

### 最新开发重点
- 提供者系统重构 (Provider System)
- 基础 UI 组件完善 (BaseView, BaseControl)
- 模块化架构优化

## 会话历史
- 2025-11-28: 用户要求将记忆存储在 CLAUDE.md 中
- 2025-12-01: 彻底重构 HomeViewController，使用规范的可复用组件
  - 创建了 DemoTableViewCell：支持自动高度计算，标题和详细描述布局
  - 创建了 DemoSectionHeaderView：规范的 Section Header，支持自动高度
  - 重写 HomeViewController：使用 UITableView.automaticDimension 实现自动高度
  - 遵循 DTBKit 命名空间和链式 API 设计原则
  - 代码结构更加清晰，支持更好的复用性和扩展性