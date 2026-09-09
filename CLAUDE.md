# DTBKit

## 项目信息
- 项目路径: /Users/admin/Documents/github/DTBKit
- 仓库: https://github.com/darkThanBlack/DTBKit
- Swift 5.0+, iOS 12.0+, XcodeGen + CocoaPods

## LLM 调用文档
- 主入口: `llms/LLMS.md`
- 这是给**使用 DTBKit 作为依赖**的 LLM 查阅的文档
- 本文件（CLAUDE.md）是 DTBKit 开发者的工作室，不要混用

## 用户偏好
- 语言: 中文

## 主题资源约定

### dtb. 前缀
- 所有主题 json（`colors` / `string_*` / `*_style`）的顶层 key 统一加 `dtb.` 前缀
- 业务自己的 key 避开 `dtb.` 开头
- 主题 key 一律写完整字面量（含 `dtb.` 前缀），禁止 `"dtb." + 变量` 拼接——拼接让 `theme_audit.sh` 无法静态识别
- 图片名（xcassets）与字体名（ttf/otf）天然有「同名后覆盖」效果，不加前缀
- `hud01/hud02.json` 是 Lottie 动画、`Assets.xcassets/**/Contents.json` 是 Xcode 资源目录，均不加前缀

### bundle 链
- `ThemeManager.bundles` 有序链，头=高优先级，业务显式传入（框架不自动发现默认主题包）
- 颜色 / 字符串 / 样式：`reversed()` 遍历逐 key 覆盖（尾先填、头后填）
- 字体 / 图片：正序遍历，先来先赢（业务 bundle 在头）
- `reloadData()` 顺序不变：颜色 → 字符串 → 字体 → 样式（样式解析时立即查颜色）

### 审计
- `Scripts/theme_audit.sh` 审计：1) 无人调用的死 key 2) 跨 json 同名 key（后覆盖风险）

## 进行中的组件设计

### SelfSizingGridView（阶段一）
- **目标**：通用「自身尺寸 == contentSize」的 collectionView 容器视图，是 ring 项目 `TouristStatGridView` 的进化结果。
- **命名**：`DTB.SelfSizingGridView` —— `SelfSizing` 突出「自身尺寸跟随内容」这一特性；后续布局模式沿用同一前缀 + 布局名（如 `SelfSizingWaterfallView`）。
- **非泛型**：视图类本身不带泛型、不 conform 数据源协议（泛型类不能在 extension 里 conform `@objc` 协议），dataSource / delegate 由外部传入。
- **封闭内部件**：`collectionView` / `layout` 保持 `private`，外部不得改动——尺寸计算由本类独占；有不同布局需求应另起一个 view，而不是改内部件。
- **数据源协议**：`DTB.SelfSizingGridDataSource` 继承 `UICollectionViewDataSource` + `UICollectionViewDelegate`，用 `associatedtype CellType` 声明唯一注册的 cell 类型；协议 extension 提供 `reuseIdentifier` 默认实现（`String(describing: CellType.self)`）。
- **泛型只落在方法上**：`setDataSource<T: SelfSizingGridDataSource>(_ source: T)` 读取 `T.CellType` 完成注册并挂 dataSource / delegate；引用语义同 UIKit（弱引用），调用方需自行持有 source。
- **配置**：布局参数集中在 `DTB.SelfSizingGridConfig`（`itemHeight` / `columnsPerRow` / `lineGap` / `columnGap`），通过 `update(_ config:numberOfItems:)` 更新，而非 init 固定。
- **阶段一布局**：grid 均分换行。item 从左到右逐行排，每行最多 `columnsPerRow` 个；`item.width = 均分当前宽度`，`item.height = itemHeight`（固定）。
- **self-sizing 实现**：公式法（行数 × itemHeight + 行距 × (行数-1)），非 contentSize KVO；前提是 cell 等高、尺寸不依赖数据。
- **契约**：外部 delegate **不实现** `sizeForItemAt`，item 尺寸统一由内部 `layout.itemSize` 决定；source 由调用方持有（视图侧是弱引用）。
- **示例 cell**：`DTB.GridCell1`（迁移自 ring 的 `TouristStatCell`）；示例数据源 `GridDemoSource` 见 `Sources/UIKit/Labs/SelfSizingGrid/`。
- **存放**：`Sources/UIKit/Classes/View/Collection/`。
