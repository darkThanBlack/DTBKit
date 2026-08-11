# UIKit — 系统交互

> subspec: `DTBKit/UIKit` | 依赖: Basic + SportTheme
> 
> **注意**: Window/Scene Provider 的源码已移至 `Sources/Basic/Window/`，但 API 仍在此处统一说明。

## Alert — 弹窗

### AlertProvider 协议

```swift
public protocol AlertProvider {
    func show(alert: AlertCreater)
}
```

### AlertCreater

```swift
let alert = DTB.AlertCreater()
    .title("提示")
    .message("确定要删除吗？")
    .addAction(
        DTB.AlertActionCreater()
            .title("取消")
            .style(.cancel)
    )
    .addAction(
        DTB.AlertActionCreater()
            .title("确定")
            .style(.destructive)
            .handler { ... }
    )

// 显示
alert.show()  // 使用已注册的 AlertProvider
```

### DefaultAlertProvider

```swift
DTB.Providers.register(DTB.DefaultAlertProvider(), key: DTB.Providers.alertKey)
```

## HUD — 加载指示器

### HUDProvider 协议

```swift
public protocol HUDProvider {
    func show(message: String?)
    func hide()
}
```

### DefaultHUDProvider

```swift
DTB.Providers.register(DTB.DefaultHUDProvider(), key: DTB.Providers.hudKey)
```

使用：
```swift
// 框架内部通过 Provider 调用
DTB.Providers.get(DTB.Providers.hudKey)?.show(message: "加载中...")
DTB.Providers.get(DTB.Providers.hudKey)?.hide()
```

## Toast — 轻提示

### ToastProvider 协议

```swift
public protocol ToastProvider {
    func show(message: String)
}
```

### DefaultToastProvider

```swift
DTB.Providers.register(DTB.DefaultToastProvider(), key: DTB.Providers.toastKey)
```

## 导航与页面结构

### 系统模式

```swift
DTB.SystemNavigationController   // 系统导航控制器
DTB.SystemTabBarController       // 系统 TabBar 控制器
```

### 自定义模式

```swift
DTB.CustomNavigationController   // 自定义导航控制器
DTB.CustomTabBarController       // 自定义 TabBar 控制器
DTB.SimpleTabBar                 // 简易 TabBar
```

### 导航栏

```swift
DTB.SimpleNavigationBar          // 简易导航栏
// CustomNavigationBarHandler    — 自定义导航栏处理器
```

## WebView

### DTB.WebView

```swift
let webView = DTB.WebView()
webView.load(URL(string: "https://...")!)
```

### JSBridge

```swift
// JSBridgePlugin — 插件协议
// JSBridgeVO     — 数据传输对象

// 注册自定义 JS 桥接插件
webView.register(plugin: MyPlugin())
```

### WebPlugin 系列

内置的 WebView 插件：

| 插件 | 说明 |
|------|------|
| `EmptyPageWebPlugin` | 空白页处理 |
| `MJRefreshWebPlugin` | 下拉刷新 |
| `ProgressWebPlugin` | 加载进度条 |
| `SystemAlertWebPlugin` | 系统弹窗 |
| `SystemHUDWebPlugin` | 加载指示器 |
| `TerminateWebPlugin` | 页面关闭 |
| `TitleWebPlugin` | 页面标题 |
| `UserAgentWebPlugin` | UserAgent |
| `WebViewPlugin` | 基础插件协议 |

## Window/Scene

> 源码已从 `Sources/UIKit/Window/` 移至 `Sources/Basic/Window/`，但 API 不变。

### WindowProvider

```swift
extension DTB.Providers {
    public protocol WindowProvider {
        func keyWindow() -> UIWindow?
    }
}

// 使用入口（StaticWrapper）
UIWindow.dtb.keyWindow()    // → UIWindow?
```

注册：
```swift
DTB.Providers.register(
    DTB.DefaultWindowProvider(window),
    key: DTB.Providers.windowKey
)
```

`DefaultWindowProvider` 提供了三级降级查找：iOS 15+ Scene keyWindow → iOS 13+ Scene windows → UIApplication.shared.keyWindow。

### SceneProvider

```swift
extension DTB.Providers {
    public protocol SceneProvider {
        func keyWindowScene() -> UIWindowScene?
    }
}

// 使用入口（StaticWrapper）
UIWindowScene.dtb.keyWindowScene()  // → UIWindowScene?
```

注册：
```swift
DTB.Providers.register(
    DTB.DefaultSceneProvider(scene),
    key: DTB.Providers.sceneKey
)
```

## 关联
- [[../concepts/provider]] — Alert/HUD/Toast/Window 都使用 Provider 模式
- [[uikit]] — 基础 UI 组件
- [[../chain]] — 相关视图的链式配置
