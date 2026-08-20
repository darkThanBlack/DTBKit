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

## 进行中的组件设计

### SelfSizingGridView（阶段一）
- **目标**：通用「自身尺寸 == contentSize」的 collectionView 容器视图，是 ring 项目 `TouristStatGridView` 的进化结果。
- **命名**：`DTB.SelfSizingGridView<Cell, Item>` —— `SelfSizing` 突出「自身尺寸跟随内容」这一特性；后续布局模式沿用同一前缀 + 布局名（如 `SelfSizingWaterfallView`）。
- **阶段一布局**：grid 均分换行。item 从左到右逐行排，每行最多 `columnsPerRow` 个；`item.width = 均分当前宽度`，`item.height = itemHeight`（固定）。
- **泛型**：`Cell`（仅一种 cell 类型）、`Item`（数据源元素）。
- **外部传入**：`itemHeight` / `columnsPerRow` / `lineGap` / `columnGap` / `cellConfig` 闭包。
- **数据源**：`update(_ items: [Item])`；**cell 渲染**：`cellConfig(_ cell:_ item:_ index:)` 闭包（因泛型，用闭包替代 dataSource 协议）。
- **self-sizing 实现**：公式法（行数 × itemHeight + 行距 × (行数-1)），非 contentSize KVO；前提是 cell 等高、尺寸不依赖数据。
- **示例 cell**：`DTB.StatCell`（迁移自 ring 的 `TouristStatCell`）。
- **存放**：`Sources/UIKit/Classes/View/Collection/`。
