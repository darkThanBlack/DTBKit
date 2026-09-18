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

### SelfSizingGridView（阶段一，已完成）
- **目标**：通用「自身尺寸 == contentSize」的网格容器视图，ring 项目 `TouristStatGridView` 的进化结果。
- **命名**：`SelfSizing` 前缀 + 布局中间词 + `View` 后缀；`Grid` = 容器均分列宽。后续 `SelfSizingFlowView`（流式）/ `SelfSizingWaterfallView`（瀑布流）。
- **无 collection / 无离屏复用**：`self.height` 全展开 ⟂ 离屏回收，故彻底抛弃 collectionView + 复用池；先期仅裸 `update(items:)` 接口（快照），业务在 map 闭包里决定「同 index 返回什么 / 是否复用缓存实例」，框架不缓存、不 diff、不 configure。数据入口是否补 `dataSource` 共存见课题 6。
- **接口**：`update(items: [UIView])`（换数据）/ `update(config:)`（换参数），都触发 `relayout()`（对内 `setNeedsLayout` + 对外 `invalidateIntrinsicContentSize`）。
- **item 契约**：item 采用「适应给定 frame」——容器给定 frame，item 内容在其内自适应；预设尺寸（列宽/itemHeight）是「内容上限」，低了压缩/截断、高了留白；item 内部不得用 required 固定尺寸约束，可伸缩用低优先级。
- **尺寸**：模式由 item 尺寸推导——`itemHeight` 固定 → 横排（`intrinsic = (noIntrinsicMetric, gridHeight)`）、`itemWidth` 固定 → 竖排（`intrinsic = (gridWidth, noIntrinsicMetric)`）、双固定 → 换行（`intrinsic = (noIntrinsicMetric, cachedHeight)`）。均分模式撑开轴总长公式法（不依赖给定轴实值、无需 invalidate）；换行模式副轴总长依赖主轴，用 `cachedSize` 收敛（同 Flow）。
- **布局**：均分模式在 `layoutSubviews` 里对均分轴求 `itemLength = (给定轴 - (per-1)×间距) / per`，横排 `index % per`/`index / per`、竖排 `index / per`/`index % per` 定位；换行模式逐项排、超界换行。
- **配置**：`SelfSizingGridConfig` 五参数 `itemWidth`/`itemHeight`（`nil`=均分、非 nil=固定）/`itemsPerLine`/`lineSpacing`/`itemSpacing`，字段 `var`；模式由「哪个非 nil」推导，不单设 axis；clamp（`max(1,...)`）在消费点不在 init。
- **示例**：`DTB.GridDemoItem`（UIView，非 cell，存于 `Sample/Gallery/Grid/`）；`SGGridViewController`（Sample 画廊页）直接 `grid.update(items: data.map {...})`。
- **存放**：`Sources/UIKit/Classes/View/Collection/`。


### SegmentView / SegmentCandy
- **切换 item 的待定决策**（记录待议，勿拍脑袋下结论）：
  - 是否重新 `add/remove` child view：目前靠 `pageView(at:)` 缓存 + `isHidden` 保活，不 remove；是否应改为 remove/add 尚未定论。
  - 是否重新触发 VC 生命周期：`addChild` 在 `pageFor` 首次走一次，`didMove(toParent:)` 延迟到 `willShowPageAt` 用 `movedIndexes`（index 为 key）保证只触发一次——`movedIndexes` 有「泄露实现细节 + index 随 `childPages` 变化错位」两个问题，应改为按 child VC 身份记录，或直接理顺 reload 时是否需重新 `addChild`。

### Sample 画廊
- **颜色收束**：Sample 内部颜色一律经 `DTB.SampleDepends` 写死 HEX（`UIColor.dtb.hex("…")`），不走 `.dtb.create`——画廊自身 UI 不随当前 mode 变化；值对应 `SportTheme/colors.json` 的 light 值。
- **目录**：`Sources/UIKit/Sample/Gallery/` 下按 json/资源拆子文件夹，每个 SG VC 展示一类资源：`Button` / `Label` / `Color` / `I18N` / `Font` / `Shape` / `Gradient` / `Container` / `Text`。
- **组件 demo 页**：`SGGridViewController`（Grid）/ `SGFlowViewController`（Flow）已从 Labs 迁入画廊，命名对齐画廊 `SG<Name>ViewController` 规范；demo item 视图 `GridDemoItem` / `FlowDemoItem` 亦随页迁入 `Sample/Gallery/{Grid,Flow}/`（离开 `Classes/View/Collection/`）；demo 页最外层统一「scrollview + stackview」包裹——内容超长可滚、未来头部加说明 label 无需动约束。
- **已暴露的读入口**：`I18NManager.mapper`、`FontManager.customFontNames`、`DefaultStylesProvider.mapper` 已改 `private(set)`（对标 `ColorManager.mapper`），供 SG 页直接读解析结果。
- **数据源结论（重要）**：画廊**只读内存值**（manager 暴露的解析结果），不直接读原始 json——渲染只能来自解析结果，且 Sample 自己解析会绕过 `friendlyParser` / auto-dark 等继承兜底逻辑，造成「画廊显示与真实渲染分叉」。凡内存里缺、但要展示的（如 i18n 多语言），应下沉到对应 manager 补全，而非在 Sample 读 json；原始 json 的「源视图」作为独立 tab 按需再做。
- **i18n 表头**：内存里只有单语言（`I18NManager.mapper` 只保留当前语言），故 `SGI18N` 表头只展示当前语言 key 一列（`currentKey ?? systemLanguageCode()`），不搞多列；多语言预览需先扩展 `I18NManager` 保留全语言 mapper + 补 `string_en.json`。
- **style 展示**：`Shape` / `Gradient` / `Container` / `Label` 已实现——从 `DefaultStylesProvider.mapper` 取 `shape_style` / `gradient_style` / `container_style` / `label_style`，各自用 `ShapeView` / `GradientView` / `ContainerView` / `Label` 垂直遍历展示（一对一的专用控件）；shape 无 fill/stroke 时预览补一个 theme 填充以便观察圆角。
- **待实现（空壳）**：`Text`（`text_style.json`）仍是占位 VC——`TextStyle` 没有一对一专用控件（只是 font+color，落到系统 UILabel），是否单独做展示页待定。
- **组件 demo 页（Label / Button）**：已从空壳补全——上半「布局展示」（参数一致、约束不同：只约束位置 / 内容撑开 / 压缩折行 / 拉长，4 种各一），下半 `Label` 读 `label_style.json` 解析、`Button` 展示业务能力（纯文本 / 纯图片 / 自定义间距 / image 4 方向 / 主轴高度大于小于文字）。`button_style.json`（15 key）的解析展示仍待定（`ButtonStyle` 含 state/title/image 等 data 属性，见课题 3）；`label_style.json` 尚未创建，故 Label 解析部分仍空。

### Alert / Present 转场容器
- **转场容器基类（Base 前缀）**：`BaseAlertViewController`（居中缩放）/ `BasePresentFitViewController`（底部上滑、高 fit content）/ `BaseSideBarViewController`（左滑抽屉、`widthRatio`）。都是 `open class` 模板：scrim + 遮罩点击 + 自定义转场由基类负责，子类只填 `contentView`（背景/圆角/排版）。`Base` 前缀强调「继承我、别直接 new」（裸 new 得空卡），与 `BaseViewController` 命名对齐。
- **数据层（struct）**：`Alert`/`AlertAction`（字符串）与 `AttributeAlert`/`AttributeAlertAction`（富文本）两套分离，各带 `extra: Any?`。分离理由：`title`（数据）与 titleLabel 的具体属性（样式）是两个维度，`NSAttributedString` 只是把两者合一「简化」；未来应下沉为 `title` + `textStyle`/`labelStyle` 分离（后话）。
- **入口收束到 VC**：`UIViewController.dtb.showAlert(on:param:)`（静态，`on` 可选源 VC）+ `vc.dtb.showAlert(param)`（实例），统一走 provider。
- **provider 契约（`Any` + `if as`）**：`AlertProvider.showAlert(on:param:)`，`Any` 参数 + `if as` 分发——`as? UIViewController` 兜底自定义形态（业务自建「标题+自定义 view+按钮」VC 直接 present）、`as? Alert` / `as? AttributeAlert` 默认 alert。`Any` 是「可插拔 provider」的开放契约：`Alert` 锁不住所有业务形态，provider 自己 `if as` 收窄；框架糖层（若要）应保持强类型，不把 `Any` 泄漏到糖。
- **默认实现一一对应**：`DefaultAlertProvider` ↔ `DefaultAlertViewController`（居中卡片，仿 `UIAlertController(.alert)`），一个 provider 实现对应一个业务 alert VC；换 provider 即换对应 VC。VC 数据入口 `Any?`（`if as` 分发 `Alert`/`AttributeAlert`），固定布局（卡片 `Container` + stack 包裹，title/message 用 `Label` 常驻 + `isHidden` 切换、buttons 动态重建），`update(creater:)` 可换数据；`init(creater:)` 仅为 buttons 布局方便。

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
- **BaseSelfSizingView（基础设施）**：把 Flow 的 `cachedSize` + `layoutSubviews` 收敛提取成通用基类（`Sources/UIKit/Classes/View/BaseSelfSizingView.swift`）。子类只实现 `layoutInferSize(by:)`（布局子视图 + 返回 inferSize；依赖轴无效返回 `cachedSize` 表示本次不算、不收敛）；基类 `layoutSubviews` 调它、缓存，结果变化且 `!translatesAutoresizingMaskIntoConstraints` 时才 `invalidateIntrinsicContentSize` 收敛。TAMIC 判断放 `layoutSubviews` 每次实时判断（业务改 TAMIC 晚于 init，不能缓存）。入口两个：`refreshAndRelayout()`（立即重算 + 触发，避免 .zero 中间态）/ `relayout()`（仅触发）。`intrinsicContentSize` 默认返回 `cachedSize`（子类 override 成 noIntrinsicMetric + cachedSize）。覆盖两种形态——无给定轴（内容自算、一次稳定，如 Button）/ 依赖给定轴（换行、靠收敛求稳，如 Flow）。`SelfSizingFlowView` 已迁入。
- **两个正交维度**：维度一「宽度策略」决定每行放几个——1) `self.width + columnsPerRow` 反推 itemSize（均分）；2) item self-sizing 反推换行（流式）。二者互斥。维度二「高度策略」决定行高——固定 `itemHeight` vs 逐行 self-sizing。
- **家族按维度一切，不按实现/高度切**：`SelfSizingGridView`（均分）/ `SelfSizingFlowView`（流式）/ `SelfSizingWaterfallView`（瀑布流，未来）。collectionView 与否只是实现细节，落在维度之下。
- **依赖顺序**：变高必须建立在「每行成员已确定」之上——先维度一（换行）后维度二（行高 = 该行 max(item 高)）；变高不是平行新家族，而是每个家族的内部演进。
- **变高终结公式法**：总高从「行数 × itemHeight」退化为「Σ 每行 max(item 高)」，且每行 max 依赖实测每个 item → 退回 `systemLayoutSizeFitting` / contentSize KVO，`SelfSizing` 系列「公式法、不碰 KVO」的立身之本失效。
- **硬边界：self.height 与 cell 复用互斥**：要拿完整总高必须全展开 + 关自身滚动 → collectionView 全量 materialize、不触发重用；离屏（被祖先推出屏幕）≠ 回收（回收只看自身 contentOffset + bounds）。小 N 用 self-sizing，大 N 用自滚动，二者是不同 view。
- **API 方向：裸数组为真身，`dataSource` 共存（`dataSource != nil` 判定），无复用/无 deq。** 先期用裸 `update(items: [UIView])` 简化；后续补 `dataSource` protocol（仅 `numberOfItems` + `itemAt`，无 `sizeForItemAt`、无 delegate），价值是「UI 与数据源分离、item 构造下沉到 model」，`reloadData()` 内 for 循环拉快照收敛回裸数组，布局引擎零 fork。离屏回收复用 ⟂ 全展开，故不提供 `dequeue`；「同 index 实例复用」职责下沉业务——model 在 `itemAt` 里自持 `[index: UIView]` 缓存（框架不缓存、不 diff、不 configure，因框架级复用需 key/命中/失效追踪，等价 diff）。调用次数确定性：`itemAt` 只在 `reloadData` 调、每 index 恰好一次，布局收敛（relayout/layoutSubviews/intrinsic 查询）绝不重调。事件无 delegate——item 非 cell，加手势易冲突，点击由 item 在 `itemAt` 内自处理。父类只规定 item 的「布局思路」（Grid=适应 frame / Flow=自报尺寸），不规定测量实现（`sizeThatFits` 手算 vs `systemLayoutSizeFitting` 约束求解由 item 自定）；不引入 `configure` / 业务手填宽度。CSS flexbox 概念（flex-basis/grow/shrink/wrap/justify）与原生 `UICollectionViewFlowLayout`+delegate 尺寸之间的取舍，仍在维度一内部待定。
- **config 边界（参数 vs 不变量）**：config 只承载「同算法换输入」的参数（`columnsPerRow` 值、gap、itemHeight），不承载「算法翻转」的不变量（谁算尺寸、怎么换行、总高怎么求、滚不滚）。可操作判据：删掉某字段 view 能否仍完整工作——能则参数，不能则是不变量、该新对象。红色信号：config 出现 `mode`/`isSelfSizing` 枚举、或某字段只在某分支下有意义（dead field）。Grid 内部演进：均分 → 比例列宽（`columnWeights: [CGFloat]?`，nil=均分、非 nil=按权重）仍是不变量内参数（都是「容器把总宽按系数分给每列、永远填满」）；到「定宽/弹性列」引入绝对宽 → 跳出「永远填满」，不变量翻转，归 Flow（`sizeForItemAt` 自报宽，天然容纳「定宽 + 内容宽」混合）或表格框架（列宽规格），非 Grid 内配置。
- **Grid/Flow 接口镜像**：同一原生方法 `sizeForItemAt` 在 Grid 是「禁」（容器独占尺寸、config 有 `columnsPerRow`），在 Flow 是「必」（item 自报尺寸、config 无 `columnsPerRow`）——用「禁/必」把宽度决策权移交写进 API 语义，学习成本趋近于零。
- **CSS flex 概念映射**：比例列宽 ≈ `flex-grow`（`flex:1` 里的 grow，均分 = 权重全 1），只取 grow「分正空间/剩余」这一半，不取 shrink「分负空间/压缩」——因为 Grid 永远填满、永无负空间；一旦要 shrink（列宽和 > 容器宽）即跳出「永远填满」，归 Flow/表格。Grid 职责收敛为「容器把一行相对填满，只管 grow」。
- **主轴 / 副轴 / 方向（不变量级，待议）**：Grid/Flow 之上存在更通用的 flex 概念——主轴（排布方向）、副轴（换行增长方向）、方向（row/column）。当前 SelfSizing 默认 row：主轴水平、副轴垂直、`self` 撑开副轴（高度）。方向翻转为 column（垂直排、水平换列）时，「self 撑开哪根轴」随之翻转（row 撑高 / column 撑宽），属不变量级而非 config 参数（塞 `direction` 就是 mode 枚举红色信号）。CSS flexbox 无「self 尺寸」概念，故「撑开轴翻转」是 SelfSizing 特有复杂度。建议：先把 row 这条线做透（变宽/变高/最后一行），摸清「主轴/副轴」在实现里的真实落点，再决定方向是独立维度还是另起 `SelfSizingColumnView`。
- **最后一行布局（空间富余的平移，参数级）**：最后一行不满 `columnsPerRow` 时，与课题 5「header 空间富余」同构（一行 item 富余怎么分）。策略：1) 保持格子（现状，左对齐、列对齐）；2) 保持格子宽 + 整体居左/中/右（justify）；3) 均分总宽（stretch，item 变宽铺满）。策略 3 使最后一行 item 比前面宽、列线错位——徽章墙要、统计卡是灾难，须可选不可默认。实现捷径：最后一行可视作「columnsPerRow=剩余个数的临时 Grid」，`itemSize` 分母换成剩余个数，不碰布局引擎与不变量。

### 7. SpreadSheet 表格框架提取（Venue）
- 来源：`XiaoMai/b/XMBusiness/Business/TaiChi/Venue` 的仿 excel 表格。
- **已拆成两层，独立课题**：
  - **7A 第一层——可复用 scroll + cell**（已落地）：`DTB.ReusableScrollView` + `DTB.ReusableCell` + `ReusableScrollViewDataSource`，见 `Sources/UIKit/Classes/View/Scroll/ReusableScrollView.swift`；demo 在 `Sample/Gallery/Scroll/`（`SGScrollViewController` + `ScrollDemoCell`，已挂画廊「Scroll」页）。研究与选型结论见 `Docs/SpreadSheet-Scroll-Layer1-Research.md`。
  - **7B 第二层——与业务分离的网格布局框架**：`SS.VenueLayoutEngine`（topo 布局），先不动。
- **核心结构**：三块同步 scrollView——左侧行表头 `leftScrollView` + 顶部列表头 `topScrollView` + 网格 `gridScrollView`，`scrollViewDidScroll` 三向联动；捏合缩放（`setScale` + 锚点 `calOffset`）。
- **布局引擎（7B）**：`SS.VenueLayoutEngine`（measure-solve-layout）——`TopoHeader`（树形/多级合并表头，children）+ `TopoGrid`（逻辑行列 + colSpan/rowSpan 占位）纯算 frame + contentSize，与 view 解耦。
- **复用机制（7A）**：`XMScrollView`（UIScrollView 子类）+ `XMScrollViewModel` + `XMReusableViewManage`（`Set<UIView>` 池）+ `XMScrollViewDataSourceManage`（可见求交），非 UICollectionView。
- **7A 能力/边界**：model 携带 `frame`+`identifier`+强引用 `view`，frame 由外部布局算好塞入；滚动回收靠消费方 `scrollViewDidScroll` 手动 `reloadLocationData()`；无 indexPath/section、无 `prepareForReuse`；联动/缩放消费方自己做。
- **7A 已发现问题（迁移必处理）**：retain cycle（`model.view` ↔ cell.model 互持，`configAllViews` 不置 nil → 换 dataSource 泄漏）；复用池 `isKind(of:)` 线性扫 O(n)、identifier 语义弱；无 `prepareForReuse`；首次 dataSource 赋值渲染为空靠 reload 兜底；model 混入 view 字段耦合数据/布局/视图。
- **7A 业内方案（已研究）**：`SpreadsheetView`（MIT/3.5k stars，UIScrollView+自建 ReuseQueue，同架构；其 `ReuseQueue`=类型化 Set 池 `dequeueOrCreate`、可见 cell=`ReusableCollection` 地址字典+`columnRecords`/`rowRecords` 二分、`LayoutEngine` 独立，可对标）vs `SwiftSpreadsheet`（UICollectionViewLayout，弱/停更）。**无独立 drop-in 的「可复用 scroll+cell」框架**：该 primitive 成熟形态只有 UICollectionView / SpreadsheetView 滚动层 / Texture（Texture 不做复用）。选型待用户拍板（A 迁移优化 XMScrollView / B UICollectionView+layout / D fork 现代化 SpreadsheetView 抽取滚动层）。详见 `Docs/SpreadSheet-Scroll-Layer1-Research.md`。
- **7A 落地决策（最终版）**：**身份 = index**（类比 indexPath），**无 item 对象**；数据源协议三方法 `numberOfItems` / `frameForItemAt(index)` / `cellForItemAt(index)`（frame 由业务算、属第二层布局）；容器只干一件事——内部 `frameForItemAt ∩ viewport` 纯数学判断 → 离屏回收、入屏渲染。**容器自驱（不劫持 delegate）**：offset（KVO `contentOffset`）、contentSize（KVO `contentSize`）、bounds（`layoutSubviews` 尺寸去重）三源自动走**增量** reconcile；`delegate` 原样留给外层（3 联动只改 offset 不管重用）。**数据变化**：index 作 key 感知不到内容变，业务换数据后显式调 `reloadData()` 做全量回收+重渲染（= UITableView `reloadData`）。`dequeueReusableCell(as:)` 按 cell 类型分桶（`ObjectIdentifier` 键，无 `register`/`cls.init`/`required init`，miss 由业务 `?? MyCell()` 创建）；cell 由 `visibleCells`（index→cell 字典）持有。**否决了**：item 对象（`ReusableScrollViewItem`）+ `ObjectIdentifier` 作 item key + IndexPath 二维 + 外部 `visibleItems` 传参。

### 8. Cell 动态高度（template cell 路线，独立课题）
- 与 SelfSizingFlowView 无关：FlowView 是「流式换行容器」（算 size），Cell 动态高度是「消费侧怎么把 size 变成 cell 高度」。
- 深度研究结论（留档 `Docs/SelfSizingFlowCell-Research.md`）：wrap-dependent（高依赖宽）的自尺寸 cell，`automaticDimension + autolayout` 天然失败——测量时宽未定。
- 五类方案：1) 参数化宽度（preferredMaxLayoutWidth 模式，layoutSubviews 重置宽）2) 离屏 template cell + heightForRowAt 缓存（测前 pin 宽）3) 手写 sizeThatFits + layoutSubviews 4) override systemLayoutSizeFitting（cell 层强制二遍）5) UICollectionViewFlowLayout + estimatedItemSize = automaticSize。
- frame 路线（2、3）对 wrap-dependent 最 robust；稍后再展开实现。

### 9. 缩放手势 + scale 计算封装（独立功能，衍生自课题 7）
- **独立性**：scale/zoom **独立于 `ReusableScrollView`**，是单独的重要功能，可单独做、单独验证。
- **落地类**：`DTB.ZoomScrollView`（`Classes/View/Scroll/ZoomScrollView.swift`，未来 `ReusableScrollView` 父类）+ `DTB.ZoomAnchorCompensation.centerOffset`（纯数学中心点补偿）。
- **API（已定）**：`scale` 替代 `zoomScale`；自定义 pinch + 中心点补偿；静态参数收拢进 `ZoomConfig`（`mechanism`/`minimumScale`/`maximumScale`）+ `update(config:)` 一次刷入；`ZoomScrollViewDelegate`（`viewForZooming(in:)` / `zoomScrollViewDidChangeScale(_:)`）仿原生 `UIScrollViewDelegate`，挂独立 `zoomDelegate`（不劫持 `delegate`）；**只保留 center 锚点**（删 `ZoomAnchor.finger`）。
- **现状**：XM 缩放 = 自定义 pinch 手势 + 中心点数学（保持视觉中心不变）；scrollview 自带 zoom 手势无此能力。
- **待完成**：1) 缩放手势冲突避免（与 scrollView 自带手势，生产级） 2) `ReusableScrollView` 继承 `ZoomScrollView` 接 scale 状态（待拍板）。
- **与 7A 解耦**：7A 的 frame 计算优化（缓存 / 排序索引）**不引入 scale**；scale 作为独立功能单独做，二者正交。
- **关联**：scale 是「纯滑动/布局变化/缩放」三态里「缩放态」的独立处理入口；7A 缓存只解决纯滑动态，缩放态由本功能负责。
