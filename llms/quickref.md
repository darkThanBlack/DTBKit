# 快速索引

按使用场景和类型快速定位到对应文档。

## 我要操作 Foundation 类型

| 类型 | 路径 | 常见方法 |
|------|------|----------|
| Data | basic.md | .string(), .ns(), .toString() |
| String | basic.md, basic-types.md | .data(), .ns(), .attr(), .count() |
| NSString | basic-types.md | .range(of:) |
| NSAttributedString | basic.md | — |
| NSMutableAttributedString | basic.md | .string(), .mString() |
| UserDefaults | basic.md | .write(codable:key:), .read(codable:) |
| Bundle | basic.md | 版本号、构建号 |
| Error | basic.md | — |
| JSON | basic.md | 编解码 |
| NSRange | basic.md | — |

## 我要操作数值类型

| 类型 | 路径 | 常见方法 |
|------|------|----------|
| Int | basic-types.md | .isZero(), .isPositive(), .isNegative() |
| Double | basic-types.md | .isFinite(), .isEmpty(), .isZero() |
| Float | basic-types.md | 同 Double |
| NSDecimalNumber | basic-types.md | 高精度小数运算 |
| NSNumber | basic-types.md | — |

## 我要操作时间

| 类型 | 路径 | 常见方法 |
|------|------|----------|
| TimeCalendar | basic-types.md | 日历相关 |
| TimeDuration | basic-types.md | 时长格式化 |
| TimeRelative | basic-types.md | 相对时间展示 |
| DateFormatter | basic-utilities.md | DTB.config.dateFormatter |

## 我要操作几何

| 类型 | 路径 | 常见方法 |
|------|------|----------|
| CGRect | basic-types.md, chain.md | .dtb.xxx() 扩展 + .dtb.create 链式 |
| CGSize | basic-types.md, chain.md | .dtb.xxx() 扩展 + .dtb.create 链式 |
| UIEdgeInsets | chain.md | .dtb.create 链式创建 |

## 我要配置 UIKit 视图（链式）

| 类型 | 路径 | 常见方法 |
|------|------|----------|
| UIView | chain.md | .backgroundColor(), .frame(), .alpha(), .clipsToBounds()... |
| UILabel | chain.md | .text(), .font(), .textColor(), .textAlignment()... |
| UIButton | chain.md | .title(), .titleColor(), .image()... |
| UIImageView | chain.md | .image(), .highlightedImage()... |
| UITextView | chain.md | .text(), .font(), .textColor()... |
| UITableView | chain.md | .separatorStyle(), .rowHeight()... |
| UIStackView | chain.md | .axis(), .spacing(), .alignment(), .distribution()... |
| UIControl | chain.md | .isEnabled(), .isSelected()... |
| CALayer | chain.md | .cornerRadius(), .borderWidth(), .shadowOpacity()... |

## 我要用 UI 组件

| 类型 | 路径 | 说明 |
|------|------|------|
| DTB.Button | uikit.md | 增强按钮（图片方向/偏移） |
| DTB.Container | uikit.md | 通用容器 |
| EdgeLabel | uikit.md | 带内边距标签 |
| GradientView | uikit.md | 渐变视图 |
| LinkTextView | uikit.md | 链接文本 |
| ShapeView | uikit.md | 形状裁剪 |
| BaseView/BaseControl/BaseViewController | uikit.md | 基类 |

## 我要用系统交互

| 功能 | 路径 | 说明 |
|------|------|------|
| Alert | uikit-system.md | 弹窗，AlertCreater + Provider |
| HUD | uikit-system.md | 加载指示器，HUDProvider |
| Toast | uikit-system.md | 轻提示，ToastProvider |
| 导航 | uikit-system.md | Custom/System 导航和 TabBar |
| WebView | uikit-system.md | 内嵌 WebView + JSBridge |
| Window | uikit-system.md | keyWindow 获取 |

## 我要配置主题

| 功能 | 路径 | 说明 |
|------|------|------|
| 颜色 | theme.md | ColorManager + ColorProvider |
| 字体 | theme.md | FontManager + FontProvider |
| 国际化 | theme.md | I18NManager + StringProvider |
| 图片 | theme.md | LocalImageProvider / RemoteImageProvider |
| 按钮样式 | theme-styles.md | ButtonStyle |
| 文本样式 | theme-styles.md | TextStyle |
| 容器样式 | theme-styles.md | ContainerStyle |

## 我要注册 Provider

| Key | 类型 | 路径 | 说明 |
|-----|------|------|------|
| Providers.windowKey | WindowProvider | uikit-system.md, provider.md | 窗口 |
| Providers.sceneKey | SceneProvider | uikit-system.md | iOS 13+ Scene |
| Providers.hudKey | HUDProvider | uikit-system.md | 加载 |
| Providers.toastKey | ToastProvider | uikit-system.md | 提示 |
| Providers.alertKey | AlertProvider | uikit-system.md | 弹窗 |
| Providers.colorKey | ColorProvider | theme.md | 颜色 |
| Providers.stringKey | StringProvider | theme.md | 国际化 |
| Providers.fontKey | FontProvider | theme.md | 字体 |

## 我要用工具方法

| 功能 | 路径 | 说明 |
|------|------|------|
| DTB.app | core.md | 内存 KV 存储 + 应用信息 |
| DTB.console | core.md | 日志（仅 debug 输出） |
| DTB.config | basic-utilities.md | 全局默认值配置 |
| DTB.check | basic-utilities.md | 可选值/空值检查 |
| DTB.any | basic-types.md | Any 安全转换 |
| HighFidelity | basic-utilities.md | 设计稿像素适配 |
| DiskCache | basic-utilities.md | 磁盘缓存管理 |
