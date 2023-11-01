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
    
import UIKit

///
extension DemoCellModel {
    
    enum CellType: String, CaseIterable {
        
        case edgeLabel, playGround, phoneCall
        
        var desc: String? {
            switch self {
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
        
        case `default`
        
        var desc: String? {
            return nil
        }
        
        var cells: [DemoCellModel.CellType] {
            switch self {
            case .default:
                return DemoCellModel.CellType.allCases
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
            
            break
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
        }
    }
}
