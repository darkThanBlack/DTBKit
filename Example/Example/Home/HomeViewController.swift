//
//  HomeViewController.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/28.
//  Copyright © 2023 darkThanBlack. All rights reserved.
//

import DTBKit

/// DTBKit Demo 主界面，展示各种功能示例
class HomeViewController: BaseViewController {
    
    private lazy var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadViews(in: view)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    private func loadViews(in box: UIView) {
        box.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        // 使用安全区域约束
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: box.safeAreaLayoutGuide.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: box.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: box.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: box.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: box.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: box.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: box.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: box.bottomAnchor)
            ])
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = view.backgroundColor
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        tableView.dtb
            .registerHeaderFooterView(HomeSectionHeaderView.self)
            .registerCell(HomeCell.self)
        return tableView
    }()
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: HomeSectionHeaderView? = tableView.dtb.dequeueReusableHeaderFooterView()
        headerView?.update(viewModel.sections.dtb[section])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections.dtb[section]?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeCell = tableView.dtb.dequeueReusableCellEnsured(indexPath)
        cell.update(viewModel.sections.dtb[indexPath.section]?.cells.dtb[indexPath.row])
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    
    private func coreEvent(_ type: DemoMenu.CoreTypes) {
        switch type {
        case .chain_memory:
            /// Note: The situation may different when a supports "copy-on-write".
            ///
            /// 注意: 当 a 支持 COW 时情况有所不同。
            ///
            /// [DEPRESSED] struct 转 class 再赋值的情况，如果是有具体定义的属性，相应的 create 方法能解决绝大多数情况下的问题，故 mutable 协议主要用于应对 dict 的创建。
            func mem_test() {
    //                var a = CGSize.dtb.create(1, 2).dtb
    //                var original = a.value
    //                print("a.width=\(a.value.width)")
    //                withUnsafePointer(to: &a, { ptr in
    //                    print("a.ptr=\(ptr)")
    //                })
    //
    //                print("STEP 01")
    //                a.width(2)
    //                print("a.width=\(a.value.width)")
    //                withUnsafePointer(to: &a, { ptr in
    //                    print("a.ptr=\(ptr)")
    //                })
    //
    //                print("STEP 02")
    //                var b = a.width(3)
    //
    //                print("a.width=\(a.value.width)")
    //                print("b.width=\(b.value.width)")
    //                withUnsafePointer(to: &a, { ptr in
    //                    print("a.ptr=\(ptr)")
    //                })
    //                withUnsafePointer(to: &b, { ptr in
    //                    print("b.ptr=\(ptr)")
    //                })
    //
    //                print("STEP 03")
    //                var result = b.width(4).value
    //
    //                print("original=\(original.width)")
    //                print("result.width=\(result.width)")
    //                withUnsafePointer(to: &original, { ptr in
    //                    print("original.ptr=\(ptr)")
    //                })
    //                withUnsafePointer(to: &result, { ptr in
    //                    print("result.ptr=\(ptr)")
    //                })
            }
            mem_test()
            
            /// a, b, c 对象相同
            func mem_test_02() {
                var l = UILabel()
                let a = l.dtb.text("a").value
                let b = a.dtb.isUserInteractionEnabled(false).value
                let c = b.dtb.text("c").value
                b.dtb.text("b")
                
                print("a.text=\(a.text!)")
                print("a.ptr=\(Unmanaged<AnyObject>.passUnretained(a).toOpaque())")
                
                print("b.text=\(b.text!)")
                print("b.ptr=\(Unmanaged<AnyObject>.passUnretained(a).toOpaque())")

                print("c.text=\(c.text!)")
                print("c.ptr=\(Unmanaged<AnyObject>.passUnretained(a).toOpaque())")
            }
            mem_test_02()
        }
    }
    
    private func otherEvent(_ type: DemoMenu.OtherTypes) {
        switch type {
        case .phone_call:
            let tels = ["10086", "tel:10086", "telprompt:10086", "telprompt://10086", "400-1234-567", "+(86) 10086", "+10086"]
            
            func parser(_ phoneStr: String) -> String {
                var result = phoneStr
                [" ", "(", ")", "-"].forEach { item in
                    result = result.replacingOccurrences(of: item, with: "")
                }
                if ["tel", "telprompt"].contains(where: { router in
                    if result.hasPrefix(router + ":") {
                        return true
                    }
                    if result.hasPrefix(router + "://") {
                        return true
                    }
                    return false
                }) {
                    return result
                }
                return "telprompt:" + result
            }
            
            let alert = UIAlertController(title: "提示", message: "打电话", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel))
            tels.forEach { phone in
                alert.addAction(UIAlertAction(title: phone, style: .default, handler: { _ in
                    if let url = URL(string: parser(phone)),
                       UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("失败")
                    }
                }))
            }
            UIViewController.dtb.topMost()?.present(alert, animated: true)

        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = viewModel.sections.dtb[indexPath.section] else {
            return
        }
        if section.title == "Core",
           let key = section.cells.dtb[indexPath.row]?.primaryKey,
           let type = DemoMenu.CoreTypes(rawValue: key) {
            coreEvent(type)
            return
        }
        if section.title == "Other",
           let key = section.cells.dtb[indexPath.row]?.primaryKey,
           let type = DemoMenu.OtherTypes(rawValue: key) {
            otherEvent(type)
            return
        }
        
        DTB.console.fail()
    }
    
}
