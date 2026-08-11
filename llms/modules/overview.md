# 模块总览

## 依赖关系

```
Core (DTBKit/Core)
├── 命名空间系统, Wrapper, ConstKey, AppManager, ConsoleManager
│
├── Chain (DTBKit/Chain)     ← 依赖 Core
│   └── UIKit/QuartzCore 链式属性设置
│
├── Theme (DTBKit/Theme)     ← 依赖 Core
│   ├── 颜色/字体/国际化/图片 (Provider 模式)
│   └── 样式系统 (ButtonStyle, TextStyle, ContainerStyle)
│
├── Basic (DTBKit/Basic)     ← 依赖 Chain + Theme
│   ├── Foundation 扩展 (Data, String, UserDefaults, Bundle, Error, JSON, NSRange)
│   ├── UIKit 扩展 (UIImage, UIImageView, UILabel, UITableView, UICollectionView, UIViewController)
│   ├── 数值类型 (Int, Double, NSDecimalNumber, NSNumber)
│   ├── 时间 (Date 扩展, 时长, 相对时间)
│   ├── 几何 (CGRect, CGSize)
│   ├── 类型转换 (AnyConvert, Date/Double/Integer/String Convert)
│   ├── Collection 扩展 (Array 安全下标)
│   ├── 格式化 (DateFormatter, NumberFormatter)
│   ├── 磁盘缓存 (DiskCacheManager, File/URL/WebView Cache)
│   ├── Optional 检查 (DTB.check)
│   ├── 高保真适配 (HighFidelity)
│   └── 工具 (Regulars, ReflectManager)
│
├── UIKit (DTBKit/UIKit)     ← 依赖 Basic + SportTheme
│   ├── 基础类 (BaseView, BaseControl, BaseViewController)
│   ├── 视图组件 (DTB.Button, Container, EdgeLabel, GradientView, ...)
│   ├── 系统交互 (Alert, HUD, Toast, 导航, WebView, Window/Scene)
│   └── 布局/动画/模型
│
├── Map (DTBKit/Map)         ← 依赖 Basic
│   └── CLLocationCoordinate2D, MKWebView 扩展
│
├── Stream (DTBKit/Stream)   ← 依赖 Core
│   └── 字节处理 (Int16/32/64 → bytes, [UInt8] → int)
│
└── 第三方集成
    ├── Kingfisher (DTBKit/Kingfisher)  ← 依赖 Theme + Kingfisher
    ├── SDWebImage (DTBKit/SDWebImage)  ← 依赖 Theme + SDWebImage
    └── ObjectMapper (DTBKit/ObjectMapper) ← 依赖 Core + ObjectMapper
```

## CocoaPods 引入

```ruby
# 全量引入
pod 'DTBKit'

# 按需引入（subspec 写法）
pod 'DTBKit/Core'          # 命名空间 + 基础设施
pod 'DTBKit/Chain'         # 链式属性设置
pod 'DTBKit/Theme'         # 主题系统
pod 'DTBKit/Basic'         # Foundation/UIKit 扩展（自动包含 Chain + Theme）
pod 'DTBKit/UIKit'         # UI 组件（自动包含 Basic）
pod 'DTBKit/Map'           # 地图扩展
pod 'DTBKit/Stream'        # 字节处理
pod 'DTBKit/Kingfisher'    # Kingfisher 集成
pod 'DTBKit/SDWebImage'    # SDWebImage 集成
pod 'DTBKit/ObjectMapper'  # ObjectMapper 集成
pod 'DTBKit/SportTheme'    # 运动主题资源包
```

## 文档索引

| 文档 | 对应 subspec | 内容 |
|------|-------------|------|
| [[core]] | Core | 命名空间, Wrapper, ConstKey, AppManager, ConsoleManager |
| [[chain]] | Chain | UIKit/QuartzCore 链式属性设置 |
| [[theme]] | Theme | 颜色/字体/国际化/图片 |
| [[theme-styles]] | Theme | 样式系统 |
| [[basic]] | Basic | Foundation/UIKit 扩展 |
| [[basic-types]] | Basic | 数值/时间/几何/转换 |
| [[basic-utilities]] | Basic | 格式化/缓存/可选值/高保真 |
| [[uikit]] | UIKit | 基础组件与视图 |
| [[uikit-system]] | UIKit | Alert/HUD/Toast/导航/WebView/Window |
| [[map]] | Map | 地图扩展 |
| [[stream]] | Stream | 字节处理 (Bytes + Gzip) |
| [[third-party]] | Kingfisher/SDWebImage/ObjectMapper | 第三方库集成 |
