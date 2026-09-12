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

### SegmentView / SegmentCandy
- **切换 item 的待定决策**（记录待议，勿拍脑袋下结论）：
  - 是否重新 `add/remove` child view：目前靠 `pageView(at:)` 缓存 + `isHidden` 保活，不 remove；是否应改为 remove/add 尚未定论。
  - 是否重新触发 VC 生命周期：`addChild` 在 `pageFor` 首次走一次，`didMove(toParent:)` 延迟到 `willShowPageAt` 用 `movedIndexes`（index 为 key）保证只触发一次——`movedIndexes` 有「泄露实现细节 + index 随 `childPages` 变化错位」两个问题，应改为按 child VC 身份记录，或直接理顺 reload 时是否需重新 `addChild`。

### Sample 画廊
- **颜色收束**：Sample 内部颜色一律经 `DTB.SampleDepends` 写死 HEX（`UIColor.dtb.hex("…")`），不走 `.dtb.create`——画廊自身 UI 不随当前 mode 变化；值对应 `SportTheme/colors.json` 的 light 值。
- **目录**：`Sources/UIKit/Sample/Gallery/` 下按 json/资源拆子文件夹，每个 SG VC 展示一类资源：`Button` / `Label` / `Color` / `I18N` / `Font` / `Shape` / `Gradient` / `Container` / `Text`。
- **已暴露的读入口**：`I18NManager.mapper`、`FontManager.customFontNames`、`DefaultStylesProvider.mapper` 已改 `private(set)`（对标 `ColorManager.mapper`），供 SG 页直接读解析结果。
- **数据源结论（重要）**：画廊**只读内存值**（manager 暴露的解析结果），不直接读原始 json——渲染只能来自解析结果，且 Sample 自己解析会绕过 `friendlyParser` / auto-dark 等继承兜底逻辑，造成「画廊显示与真实渲染分叉」。凡内存里缺、但要展示的（如 i18n 多语言），应下沉到对应 manager 补全，而非在 Sample 读 json；原始 json 的「源视图」作为独立 tab 按需再做。
- **i18n 表头**：内存里只有单语言（`I18NManager.mapper` 只保留当前语言），故 `SGI18N` 表头只展示当前语言 key 一列（`currentKey ?? systemLanguageCode()`），不搞多列；多语言预览需先扩展 `I18NManager` 保留全语言 mapper + 补 `string_en.json`。
- **style 展示**：`Shape` / `Gradient` / `Container` / `Label` 已实现——从 `DefaultStylesProvider.mapper` 取 `shape_style` / `gradient_style` / `container_style` / `label_style`，各自用 `ShapeView` / `GradientView` / `ContainerView` / `Label` 垂直遍历展示（一对一的专用控件）；shape 无 fill/stroke 时预览补一个 theme 填充以便观察圆角。
- **待实现（空壳）**：`Text`（`text_style.json`）仍是占位 VC——`TextStyle` 没有一对一专用控件（只是 font+color，落到系统 UILabel），是否单独做展示页待定。
- **待定**：`button_style.json`（15 key）的展示——`Button` 仍是手写组件 demo，且 `ButtonStyle` 含 state / title / image 等 data 属性（见课题 3）；`label_style.json` 尚未创建，故 `Label` 页目前为空。

## 研究课题

### 1. 页面结构相关
- 如何在 `BaseViewController` 里实现 `StatusBarStyle` 受 `NavigationBar` 驱动
- `Config.Themes` 的具体实现处理
- 根据导航栏视觉内容推测出 `statusBarStyle`

### 2. Demo 展示设计
- 如何设计更好的 demo 展示，能够直观展示现有框架内容和能力，并调试视觉问题

### 3. Button 状态配置重构
- `DTB.Button` 的 `config` 和 `match` 在实现自动点击变暗效果时体现出局限性，如何重构
- 当 style 来到 label 和 button 层面时，不可避免地需要决定 style 是否包含比如 title, image 这些 data 层面的属性

### 4. 页面恢复 / VC 结构范式
- 用自研恢复系统替代系统 `shouldRestoreApplicationState` 及相关 API（`UIStateRestoration` / `UIViewControllerRestoration`）
- 第一步：调整现有 VC 结构范式，使导航/层级可被描述与重建；画廊展示区 item VC（`SegmentCandy` 承载）作为该范式的探索者

### 5. Segment 布局与交互
- **空间富余时 header/headerItem 的处理**：item 保持固有宽度，富余空间分配策略——1) 均分进间隔（`.equalSpacing` / `.equalCentering`，二者在 item 宽度不一时视觉不同）；2) 间隔不变、整体打包：居左 / 居中 / 居右。首/尾内部 padding 也有业务价值，需明确 padding 与「居中/打包」的交互（padding 是最小下限 floor，还是居中时忽略）。结论：`.fillEqually`（改 item 自身宽度）是唯一会压出省略号的分支，应从策略集剔除；`needsScroll = totalContent > bounds.width` 对「平铺」判据正确。滚动分支无富余空间，固定间隔 + 打包 + 滚，padding 语义变为 `contentInset`。
- **pageContent 约束叠加**：`SegmentView.showPage(at:)` 切换页面时旧 page 只 `isHidden = true`，其 edges 约束并未 deactivate，会在同一 container 上随切换逐次累加（已确认会引发约束冲突，但并非 header 被拉伸的根因）。
- **header 计算同时适应 autolayout / frame**：header 高度走 autolayout（`intrinsicContentSize` / SnapKit 约束），但宽度/滚动判断却在 `layoutSubviews` 里用 `bounds.width` 手动量 item 宽度（frame 思维）；两种布局范式的边界与职责如何划分、如何在一个组件里共存（尺寸用 autolayout 求、滚动阈值用 frame 手动算，是否要统一成一种）。
- **header 与 pageContent 的相对位置/布局自定义**：当前 `reloadData()` 硬编码 header 在顶（top/left/right）、pageContainer 在 header 下（top=header.bottom, left/right/bottom）；需支持 header 位置（顶/底/侧）、pageContent 边距、header 高度（intrinsic vs 固定）、是否允许外部自定义 header 布局。

### 6. SelfSizing 系列（网格家族）
- **两个正交维度**：维度一「宽度策略」决定每行放几个——1) `self.width + columnsPerRow` 反推 itemSize（均分）；2) item self-sizing 反推换行（流式）。二者互斥。维度二「高度策略」决定行高——固定 `itemHeight` vs 逐行 self-sizing。
- **家族按维度一切，不按实现/高度切**：`SelfSizingGridView`（均分）/ `SelfSizingFlowView`（流式）/ `SelfSizingWaterfallView`（瀑布流，未来）。collectionView 与否只是实现细节，落在维度之下。
- **依赖顺序**：变高必须建立在「每行成员已确定」之上——先维度一（换行）后维度二（行高 = 该行 max(item 高)）；变高不是平行新家族，而是每个家族的内部演进。
- **变高终结公式法**：总高从「行数 × itemHeight」退化为「Σ 每行 max(item 高)」，且每行 max 依赖实测每个 item → 退回 `systemLayoutSizeFitting` / contentSize KVO，`SelfSizing` 系列「公式法、不碰 KVO」的立身之本失效。
- **硬边界：self.height 与 cell 复用互斥**：要拿完整总高必须全展开 + 关自身滚动 → collectionView 全量 materialize、不触发重用；离屏（被祖先推出屏幕）≠ 回收（回收只看自身 contentOffset + bounds）。小 N 用 self-sizing，大 N 用自滚动，二者是不同 view。
- **API 方向：不用 dataSource protocol，用裸 `reload(_ views: [UIView])`。** 理由链：业务对同 index 可自由返回不同类型/实例（cellForRow 完整语义）→ 该能力靠复用池支撑；但复用池 ⟂ self.height 全展开（硬边界，需滚动回收）→ 完善 protocol 在 SelfSizing 约束下自相矛盾；砍掉复用池的「询问式 protocol」退化成「业务自己 map」的多余间接层。故 protocol 只有两条路——完善（需复用，归「大 N 自滚动」另起线）或不用（SelfSizing 选不用）。接口收敛为 `update(_ config:)` + `reload(_ views:)` 两个裸方法；业务自行在 map 闭包里决定「同 index 返回什么/是否复用缓存实例」，框架不缓存、不 diff、不 configure。测量走 `sizeThatFits`（UIView 规范接口），不引入 `configure` / 业务手填宽度。CSS flexbox 概念（flex-basis/grow/shrink/wrap/justify）与原生 `UICollectionViewFlowLayout`+delegate 尺寸之间的取舍，仍在维度一内部待定。
- **config 边界（参数 vs 不变量）**：config 只承载「同算法换输入」的参数（`columnsPerRow` 值、gap、itemHeight），不承载「算法翻转」的不变量（谁算尺寸、怎么换行、总高怎么求、滚不滚）。可操作判据：删掉某字段 view 能否仍完整工作——能则参数，不能则是不变量、该新对象。红色信号：config 出现 `mode`/`isSelfSizing` 枚举、或某字段只在某分支下有意义（dead field）。Grid 内部演进：均分 → 比例列宽（`columnWeights: [CGFloat]?`，nil=均分、非 nil=按权重）仍是不变量内参数（都是「容器把总宽按系数分给每列、永远填满」）；到「定宽/弹性列」引入绝对宽 → 跳出「永远填满」，不变量翻转，归 Flow（`sizeForItemAt` 自报宽，天然容纳「定宽 + 内容宽」混合）或表格框架（列宽规格），非 Grid 内配置。
- **Grid/Flow 接口镜像**：同一原生方法 `sizeForItemAt` 在 Grid 是「禁」（容器独占尺寸、config 有 `columnsPerRow`），在 Flow 是「必」（item 自报尺寸、config 无 `columnsPerRow`）——用「禁/必」把宽度决策权移交写进 API 语义，学习成本趋近于零。
- **CSS flex 概念映射**：比例列宽 ≈ `flex-grow`（`flex:1` 里的 grow，均分 = 权重全 1），只取 grow「分正空间/剩余」这一半，不取 shrink「分负空间/压缩」——因为 Grid 永远填满、永无负空间；一旦要 shrink（列宽和 > 容器宽）即跳出「永远填满」，归 Flow/表格。Grid 职责收敛为「容器把一行相对填满，只管 grow」。
- **主轴 / 副轴 / 方向（不变量级，待议）**：Grid/Flow 之上存在更通用的 flex 概念——主轴（排布方向）、副轴（换行增长方向）、方向（row/column）。当前 SelfSizing 默认 row：主轴水平、副轴垂直、`self` 撑开副轴（高度）。方向翻转为 column（垂直排、水平换列）时，「self 撑开哪根轴」随之翻转（row 撑高 / column 撑宽），属不变量级而非 config 参数（塞 `direction` 就是 mode 枚举红色信号）。CSS flexbox 无「self 尺寸」概念，故「撑开轴翻转」是 SelfSizing 特有复杂度。建议：先把 row 这条线做透（变宽/变高/最后一行），摸清「主轴/副轴」在实现里的真实落点，再决定方向是独立维度还是另起 `SelfSizingColumnView`。
- **最后一行布局（空间富余的平移，参数级）**：最后一行不满 `columnsPerRow` 时，与课题 5「header 空间富余」同构（一行 item 富余怎么分）。策略：1) 保持格子（现状，左对齐、列对齐）；2) 保持格子宽 + 整体居左/中/右（justify）；3) 均分总宽（stretch，item 变宽铺满）。策略 3 使最后一行 item 比前面宽、列线错位——徽章墙要、统计卡是灾难，须可选不可默认。实现捷径：最后一行可视作「columnsPerRow=剩余个数的临时 Grid」，`itemSize` 分母换成剩余个数，不碰布局引擎与不变量。

### 7. SpreadSheet 表格框架提取（Venue）
- 来源：`XiaoMai/b/XMBusiness/Business/Taichi/Venue` 的仿 excel 表格。
- **核心结构**：三块同步 scrollView——左侧行表头 `leftScrollView` + 顶部列表头 `topScrollView` + 网格 `gridScrollView`，`scrollViewDidScroll` 三向联动；捏合缩放（`setScale` + 锚点 `calOffset`）。
- **布局引擎**：`SS.VenueLayoutEngine`（measure-solve-layout）——`TopoHeader`（树形/多级合并表头，children）+ `TopoGrid`（逻辑行列 + colSpan/rowSpan 占位）纯算 frame + contentSize，与 view 解耦。
- **复用机制**：`XMScrollView` + `XMScrollViewModel`（自定义可复用滚动容器 + 模型协议，非 UICollectionView）。
- **待提取框架层**：冻结行/列表头 + 网格、三向滚动同步、缩放、topo 布局引擎、可复用滚动容器 + 模型协议；业务部分（场地/预订/时段状态、Butterfly VO）剔除。
