//
//  DemoDefines.swift
//  DTBKit_Example
//
//  Created by moonShadow on 2023/6/30
//  Copyright © 2023 darkThanBlack. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//

import DTBKit

///
extension DemoCellModel {
    
    enum BaseCellType: String, CaseIterable {
        
        case chain_struct, chain_class, edgeLabel, playGround, phoneCall, hexColor
        
        var desc: String? {
            switch self {
            case .chain_struct:  return "值类型内存状态测试"
            case .chain_class:   return "引用类型内存状态测试"
            case .edgeLabel:  return "带内边距的 UILabel"
            default:
                return nil
            }
        }
    }
}

///
extension DemoSectionModel {
    
    enum SectionType: String, CaseIterable {
        
        case base
        
        var desc: String? {
            switch self {
            case .base:  return nil
            }
        }
        
        var cells: [DemoCellModel.BaseCellType] {
            switch self {
            case .base:
                return DemoCellModel.BaseCellType.allCases
            }
        }
    }
}

// MARK: -

///
class DemoEntry: NSObject {
    
    let sections: [DemoSectionModel]
    
    init(sections: [DemoSectionModel]) {
        self.sections = sections
    }
}

extension DemoEntry: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = sections[indexPath.section].cells[indexPath.row]
        
        switch cellModel.type {
        case .chain_struct:
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
        case .chain_class:
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
        case .edgeLabel:
            SimpleVisualViewController.show(in: {
                let label = EdgeLabel()
                label.text = "Edge Label"
                label.textColor = .systemRed
                label.backgroundColor = .systemYellow
                label.edgeInsets = UIEdgeInsets(top: 4.0, left: 16.0, bottom: 8.0, right: 32.0)
                return label
            }, behavior: .center)
        case .playGround:
            
            func isPhoneNumber(_ value: String) -> Bool {
                let mobile = "^\\d{11}$"
                let reg = NSPredicate(format: "SELF MATCHES %@",mobile)
                return reg.evaluate(with: value)
            }
            
            print("result=\(isPhoneNumber("182****9683"))")
            
            let cc = SetupVC()
            cc.fire()
        case .phoneCall:
            
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
            
            break
        case .hexColor:
            SimpleVisualViewController.show(in: {
                let label = EdgeLabel()
                label.text = "hex color"
                label.textColor = .systemRed
                label.backgroundColor = DemoEntry.convertHashHex("#FF8534")
                label.edgeInsets = UIEdgeInsets(top: 4.0, left: 16.0, bottom: 8.0, right: 32.0)
                return label
            }, behavior: .center)
            
//            let test = "https://dev.xiaomai5.com/poster-page/pagetwo/index.html?id=1731585995723845634&shareType=STUDY_PLAN&aid=1635486434794536962&b=553635&deviceVersion=16.4&instId=1265190592995299330&p=iOS&saasV=5.0&tid=1635486434794536962&token=ecddcf73ddcd40d7b8484e32adae84f3&uid=1630460942907846657&userType=B&v=5.11.51&vn=5.11.51&xmversion=5.0"
//            let baseUrl = URL(string: "")
//            let com = URLComponents(string: test)
//            print("")
        }
    }
    
    /// #FF8534 -> UIColor
    /// 0xFF8534 -> UIColor
    private static func convertHashHex(_ value: String) -> UIColor? {
        let preCheck = value.trimmingCharacters(in: .whitespaces).lowercased()
        var aligned = preCheck
        ["#", "0x"].forEach { item in
            aligned = value.replacingOccurrences(of: item, with: "")
        }
        guard aligned.count == 6 else {
            return nil
        }
        guard let num = Int(aligned, radix: 16) else {
            return nil
        }
        return UIColor(
            red: CGFloat((Float((num & 0xff0000) >> 16)) / 255.0),
            green: CGFloat((Float((num & 0x00ff00) >> 8)) / 255.0),
            blue: CGFloat((Float((num & 0x0000ff) >> 0)) / 255.0),
            alpha: 1.0
        )
    }
}


// --- protocol text


protocol CommonSetupable: AnyObject {
    
    var title: String? { get set }
}

class Request: CommonSetupable {
    
    var title: String?
    
    init(title: String? = nil) {
        self.title = title
    }
}

protocol CommonSetuper {
    
    associatedtype ModelType: CommonSetupable
    
    var model: ModelType? { get set }
    
    func setup()
}

extension CommonSetuper {
    
    func setup() {
        model?.title = "2"
    }
}

class SetupVC: CommonSetuper {

    var model: Request? = Request(title: "1")
    
//    var model: CommonSetupable? {
//        get { return request }
//        set { self.request = newValue as? Request }
//    }
    
    func fire() {
        print(model?.title)
        setup()
        print(model?.title)
    }
}
