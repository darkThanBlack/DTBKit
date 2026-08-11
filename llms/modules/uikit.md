# UIKit — 基础组件与视图

> subspec: `DTBKit/UIKit` | 源码: `Sources/UIKit/Classes/` | 依赖: Basic + SportTheme

## 概述

UIKit 模块提供了一系列 UI 组件，包括基础类、常用视图组件和布局工具。

## 基础类

### BaseView

```swift
open class BaseView: UIView, Chainable {
    // 提供通用的视图基类
}
```

### BaseControl

```swift
open class BaseControl: UIControl, Chainable {
    // 提供通用的控件基类
}
```

### BaseViewController

```swift
open class BaseViewController: UIViewController {
    // 提供通用的控制器基类
}
```

## 视图组件

### DTB.Button

```swift
let button = DTB.Button()
button.setImageDirection(.right)       // 图片位置
button.setImageOffset(.init(dx: 4, dy: -1))  // 图片偏移
```

增强的 UIButton，支持图片方向和偏移控制。

### DTB.Container

通用的容器视图组件。

### EdgeLabel

带内边距的 UILabel。

### GradientView

渐变背景视图。

### LinkTextView

支持链接点击的 UITextView。

### ShapeView

形状视图，支持圆角等裁剪。

### VoidView / VoidLayer

空白占位视图/层。

### Crumbs 系列

面包屑导航相关组件：
- `Crumb1`, `Crumb2`, `Crumb3` — 面包屑节点
- `CrumbsView` — 面包屑导航视图
- `CrumbsTableViewCell` — 面包屑表格单元格
- `CrumbsSampleView` — 面包屑示例视图

## TableView 组件

### ContainerTableViewCell

通用容器表格单元格。

### IndexOrder（已废弃）

列表中元素的位置枚举（`onlyOne`/`isFirst`/`isMiddle`/`isLast`），连同 `verticalCorners` 计算属性已被注释废弃。表格卡片的圆角样式应通过 JSON 配置文件定义，不再依赖运行时索引计算。

## 模型

### CellModel / SectionModel

```swift
// 表格数据模型
struct CellModel { ... }
struct SectionModel { ... }
```

### ImageData

图片数据模型。

### SampleData / SampleDelegate

示例数据与代理协议。

### TabBarModel / TabBarItemModel

TabBar 数据模型。

## 布局

### LayoutManager

```swift
DTB.layout   // 全局布局管理器
```

基于 SnapKit 的布局辅助工具。

### DTBStatics

静态布局常量工具。

### LayoutEventLazyFireable

延迟触发布局事件的协议。

## 动画

### AlertAnimation

```swift
// Alert 弹出/消失的过渡动画
DTB.AlertAnimation
```

## 关联
- [[../concepts/chain]] — 所有组件遵守 Chainable，支持链式配置
- [[uikit-system]] — Alert/HUD/Toast/导航/WebView/Window
- [[../chain]] — UIView 等类型的链式扩展
