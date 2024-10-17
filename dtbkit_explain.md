# 如何理解



> 有些 API 的用法和设计思路需要更细致的说明，而有可能
>
> * 有多个同一类设计的 API，每个 API 都写注释不合适；
> * 代码示例放在注释中不够直观；
>
> 所以有了 "如何理解" 系列，作为对代码注释的丰富和补充。



#### DTB.ConstKey

首先，你需要学会使用并通读 [DefaultsKit](https://github.com/nmdias/DefaultsKit) 源码，在此基础上，可以观察到

* 带泛型的 key 的思路，可以有更广泛的应用场景，而非局限于对 UserDefaults 扩展上；
* 项目中一般会用自己的 JSON 模型解析库，而非局限于 ``Codable``。

基于以上两点，按照  [DefaultsKit](https://github.com/nmdias/DefaultsKit) 的源码重新实现了一遍，并将 ``ConstKey`` 放到了基础依赖中。



#### UITableView / UICollectionView: register / dequeueReusable

观察一个典型的业务：

```swift
tableView.register(BusCell.self, forCellReuseIdentifier: "BusCellIdentifier")

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard indexPath.row < viewModel.cells.count, let cellModel = viewModel.cells[indexPath.row] else {
        return UITableViewCell()
    }
    switch cellModel.bizType {
        case .bus:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusCellIdentifier") as? BusCell else {
            return UITableViewCell()
        }
        cell.config(cellModel.bus)
        return cell
        case .car:
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CarCellIdentifier") as? CarCell else {
            return UITableViewCell()
        }
        cell.config(cellModel.car)
        return cell
    }
}
```

一般会用类名来替代硬编码：

```swift
tableView.register(BusCell.self, forCellReuseIdentifier: String(describing: BusCell.self))
```

引入辅助方法后，可以略微简化空判断，使业务代码更易读：

```swift
tableView.xm.register(BusCell.self)

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cellModel = viewModel.cells.xm[indexPath.row] else {
        return UITableViewCell()
    }
    switch cellModel.bizType {
        case .bus:
        let cell: BusCell = tableView.xm.dequeueReusableCell(indexPath)
        cell.config(cellModel.bus)
        return cell
        case .car:
        let cell: CarCell = tableView.xm.dequeueReusableCell(indexPath)
        cell.config(cellModel.car)
        return cell
    }
}
```

观察实现源码，有些人使用 ``as!`` 来处理，不建议这么做：

```swift
public func dequeueReusableCell<T: UITableViewCell>(_ indexPath: IndexPath) -> T {
        if let cell = me.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T {
            return cell
        }
        assert(false)
        return T()
    }
```



#### Date: toDynamic

需求：当前时间相对于给定的时间，过去了多久；举个例子，输出结果有可能是下列之一：

```shell
刚刚
3分钟前
今天 16:59
昨天 18:06
10-09 18:06
2023-10-16 18:06
```

一个典型的业务实现：

```swift
public extension Date {
	/// 动态时间显示
    var toDynamicString: String {
        let currentDate = Date()
        let interval = currentDate.timeIntervalSince1970 - timeIntervalSince1970
        if interval < 0 {
            return toString()
        }
        if interval < 60 {
            return "刚刚"
        }
        if interval < 3600 {
            return "\(Int(interval / 60))分钟前"
        }
        
        let dateString = toString(with: "yyyy-MM-dd")
        let currentDayString = currentDate.toString(with: "yyyy-MM-dd")
        if dateString == currentDayString {
            return "今天 \(toString(with: "HH:mm"))"
        }
        let yeaterdayString = currentDate.addingDays(-1).toString(with: "yyyy-MM-dd")
        if dateString == yeaterdayString {
            return "昨天 \(toString(with: "HH:mm"))"
        }
        if currentDate.toString(with: "yyyy") == toString(with: "yyyy") {
            return toString(with: "MM-dd HH:mm")
        }
        return toString()
    }
}
```

实现正常，但这个需求有茫茫多的变体，无法通用。略去思考过程，直接说思路：

* 将时间视为从过去到未来的单向坐标轴，原点是现在；
* 时间轴可以根据业务，随意切分成有限的几段，显然，各个线段之间不会重叠；
* 这时，可以建立一对一映射，将每一个片段转换为对应的字符串，而每个转换方法只需要考虑自己的判断条件是否符合，无需通盘考虑其他情况。

把接口雏形写出来：

```swift
public func toDynamic(_ barrier: [((Date) -> String?)]) -> String? {
    return barrier.first(where: { $0(me) != nil })?(me)
}
```

很容易看出来，barrier 数组从最早的过去（负无穷）开始，向着最远的未来（正无穷）依次判断；将之前的业务代码判断转写成 barrier，就可以实现相同的效果：

```swift
let myBarrier: [((Date) -> String?)] = [
	{ to in
        let delta = Date().timeIntervalSince1970 - to.timeIntervalSince1970
        return delta < 60 ? "刚刚" : nil
    }(),
    { to in
        let delta = Date().timeIntervalSince1970 - to.timeIntervalSince1970
        return delta < 3600 ? "\(Int(delta / 60))分钟前" : nil
    }(),
    // etc...
    { to in
        return to.toString()
    }()
]
```

这样，我们建立了 ``整条时间轴 => [barrier] => [String]``的映射关系；每个业务可以撰写自己的 barrier，而无需调整 ``toDynamic`` 方法本身。接下来，只需要基于雏形代码进行细化：

* 返回非可选值并加以断言拦截，因为 barrier 永远需要覆盖到整条时间轴；
* 让坐标轴原点可以自由调整；
* 增加语法糖方便调用。

最终，如果你需要定义自己的映射，创建自己的 ``DateDynamicBarrierItem`` 即可；``baseOn`` 参数表示坐标轴原点，默认是当前时间 ``Date()``：

```swift
extension DTB.DateDynamicBarrierItem {
    /// 一分钟内 | "刚刚"
    public static let oneMinute = Self { base, to in
        let delta = base.timeIntervalSince1970 - to.timeIntervalSince1970
        return delta < 60 ? "刚刚" : nil
    }
}
```

业务方的调用代码类似于：

```swift
timeLabel.text = model.createDate?.dtb.plusWeek(-1).toDynamic()

static let myRule: [DTB.DateDynamicBarrierItem] = [
    .myPass("EEE HH:mm"), 
    .myTime01, 
    .myTime02, .myFuture()
]
date.dtb.toDynamic(MyManager.myRule)
```

