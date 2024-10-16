# 如何理解



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





 
