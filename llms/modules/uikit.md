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

### PathBar / FileBrowser 系列

文件浏览器的**纯 UI 组件**：面包屑路径条 + 列表。三种输入的性质是分开的 ——
**路径是同步且确定的**（`update(paths:)` 喂进来）、**内容是异步的**（数据源回调）、**事件只报「第几项」**（换不换路径由上层决定）。
数据源与事件全部 protocol 化：换一套实现（内存 / 本地沙盒 / 云端）只换数据源，UI 层零改动。
**只管浏览**：没有选中态、没有上下拉刷新、没有分页。

```swift
// 1. 数据源：路径 → 这一层的内容，异步作答
//    必须回主线程回调；空数组 = 这一层确实没有内容（会显示空态文案）；缓存命中可以直接同步回调
final class SandboxSource: DTB.FileBrowserDataSource {
    func fileBrowser(_ browser: DTB.FileBrowserView,
                     nodesOf path: [any DTB.PathNode],
                     completion: @escaping ([any DTB.FileNode]) -> Void) {
        let id = path.last!.nodeID            // 只关心当前层时用 path.last 就够了
        DispatchQueue.global().async {
            let nodes: [any DTB.FileNode] = [] // FileManager 读一层，吐 [SandboxNode]
            DispatchQueue.main.async { completion(nodes) }
        }
    }
}

// 2. 组装
let browser = DTB.FileBrowserView()
browser.dataSource = source
browser.delegate = self
browser.update(paths: [root])   // 路径同步喂进去；内容由数据源异步补上（期间显示「加载中…」）

browser.paths                   // 当前路径（根在最前）
browser.nodes                   // 当前层内容；取内容期间是空的

// 3. 事件：只报「第几项」，要不要换路径、换到哪儿都由这一层决定
func fileBrowser(_ b: DTB.FileBrowserView, willSelectPath node: any DTB.PathNode) -> Bool {
    return true                 // 默认实现就是 true；返回 false = 这次点击整个作废（这条路径进不去）
}
func fileBrowser(_ b: DTB.FileBrowserView, didSelectAt index: Int) {
    let node = b.nodes[index]   // 文件夹 → 路径栈 push 后 update(paths:)；文件 → 预览 / 下载
}
func fileBrowser(_ b: DTB.FileBrowserView, didTapBreadcrumb node: any DTB.PathNode, at index: Int) {
    // 路径栈 trim → update(paths:)
}
```

完整装配示例（路径栈 + 路径上每一层的名字 + 异步 mock 数据源）见 `SGFileBrowserViewController`。

节点：业务 model 实现 `DTB.FileNode` 即可 —— 必需 `nodeID`（**全局唯一 + 跨 reload 稳定 + 禁用展示名**）、
`nodeName`、`nodeKind`；`nodeSize` / `nodeIconToken` 有默认值。
（**没有 `isLocked`**：「哪些路径进不去」由 `willSelectPath` 表达，不是节点的属性。）

| 组件 | 说明 |
|---|---|
| `DTB.PathBarView` | 面包屑路径条：可滚动、两端固定渐隐（提示末端还有内容）、当前层强调。吃 `[any PathNode]`，每次喂数据都对齐到当前层；事件走 `DTB.PathBarDelegate` |
| `DTB.FileListView` | 列表哑组件：吃 `[any FileNode]`，行高自适应，事件走 `DTB.FileListViewDelegate`（只报第几行，不认业务模型） |
| `DTB.FileRowView` | 行视图：即 `Crumb1` 的布局（H[文字列, spacer, 尾部图]）在左侧多一个图标盒 |
| `DTB.FileBrowserView` | 组合件：路径条 + 列表 + 状态文案 + 取内容（`update(paths:)`）；事件统一走 `DTB.FileBrowserDelegate`。**不推栈、不缓存、不知道下一层是哪一层** |
| `DTB.FileBrowserDataSource` | 内容源契约（`nodesOf:completion:`，异步）：`FileBrowserView` 持它取当前层内容 |
| `DTB.FilePathStack` | 路径栈（纯逻辑，只认 id）：给上层做「现在在哪一层」用（push 防环 / trim 越界 clamp） |

状态只有一句文案：取内容期间显示 `loadingText()`，回调回来是空数组则显示 `emptyText()`（列表与这句文案互斥）。
外观与文案收束在 `DTB.FileBrowserDepends`（仿 `DTB.DiskUsageDepends`）：换皮 / 换文案 / 换图标只改这一个文件
（尺寸与字号就地写字面量，不在这里）。默认图标走 SF Symbol（iOS 13+；低版本返回 nil，按「无图标」降级）。

- `willSelectPath` 问的是**路径类操作**：面包屑上任一祖先项 + 列表里的**文件夹行**；文件行不上闸（它不是路径）。
- `nodeID` 违约（空 / 同层重复）由框架兜底：`DTB.console.error` 并丢弃该行，不会渲染出两行同一个 id。
- 过期回调由框架丢弃（请求序号）：来回快速点击不会渲染出旧路径的内容。
- 节点**不持有子树**（不是 `subNode: [Self]` 那种树）：数据源回答「某节点下有什么」，于是「空文件夹」与「还没加载」天然可分。

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
