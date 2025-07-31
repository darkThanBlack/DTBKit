// 保存为 analyze_swift_uiview.swift
import Foundation
import SourceKittenFramework

// 分析 UIKit 模块中的 UIView
func analyzeUIView() throws -> [String: Any] {
    // 使用 SourceKitten 的 Module 功能直接分析 Swift 模块
    let module = Module(name: "UIKit")
    guard let docs = try? module.docs() else {
        throw NSError(domain: "SourceKittenError", code: 1, userInfo: [NSLocalizedDescriptionKey: "无法获取 UIKit 文档"])
    }
    
    // 查找 UIView 的文档信息
    var uiviewInfo: [String: Any] = [:]
    var uiviewMembers: [[String: Any]] = []
    
    // 处理顶级声明
    for item in docs {
        guard let dict = item as? [String: Any],
              let name = dict["key.name"] as? String,
              let kind = dict["key.kind"] as? String else { continue }
        
        // 寻找 UIView 类
        if name == "UIView" && kind == "source.lang.swift.decl.class" {
            uiviewInfo = dict
            
            // 查找 UIView 的成员 (属性、方法等)
            if let substructure = dict["key.substructure"] as? [[String: Any]] {
                for member in substructure {
                    if let memberKind = member["key.kind"] as? String,
                       let memberName = member["key.name"] as? String {
                        
                        var memberInfo: [String: Any] = [:]
                        memberInfo["name"] = memberName
                        memberInfo["kind"] = memberKind
                        
                        // 获取访问级别
                        if let accessibility = member["key.accessibility"] as? String {
                            memberInfo["accessibility"] = accessibility
                            
                            // 只收集公开 API
                            if accessibility != "source.lang.swift.accessibility.public" {
                                continue
                            }
                        }
                        
                        // 获取类型信息
                        if let typeName = member["key.typename"] as? String {
                            memberInfo["type"] = typeName
                        }
                        
                        // 获取位置信息
                        if let offset = member["key.offset"] as? Int64,
                           let length = member["key.length"] as? Int64 {
                            memberInfo["offset"] = offset
                            memberInfo["length"] = length
                        }
                        
                        // 获取可用性信息
                        if let attributes = member["key.attributes"] as? [[String: Any]] {
                            var availabilityInfo: [String: Any] = [:]
                            
                            for attr in attributes {
                                if let attrName = attr["key.attribute"] as? String {
                                    if attrName == "source.decl.attribute.available" {
                                        if let arguments = attr["key.arguments"] as? [[String: Any]] {
                                            for arg in arguments {
                                                if let platform = arg["key.name"] as? String,
                                                   let version = arg["key.value"] as? String {
                                                    availabilityInfo[platform] = version
                                                }
                                                
                                                // 处理弃用信息
                                                if let deprecated = arg["key.deprecated"] as? String {
                                                    availabilityInfo["deprecated"] = deprecated
                                                }
                                                if let obsoleted = arg["key.obsoleted"] as? String {
                                                    availabilityInfo["obsoleted"] = obsoleted
                                                }
                                                if let message = arg["key.message"] as? String {
                                                    availabilityInfo["message"] = message
                                                }
                                            }
                                        }
                                    } else if attrName == "source.decl.attribute.override" {
                                        memberInfo["isOverride"] = true
                                    }
                                }
                            }
                            
                            if !availabilityInfo.isEmpty {
                                memberInfo["availability"] = availabilityInfo
                            }
                        }
                        
                        // 处理属性特有的信息
                        if memberKind.contains("var") {
                            // 检测是否是只读属性
                            if let accessors = member["key.accessors"] as? [[String: Any]] {
                                let isReadOnly = accessors.count == 1 &&
                                               (accessors[0]["key.accessibility"] as? String == "source.lang.swift.accessibility.internal" ||
                                                accessors[0]["key.name"] as? String == "get")
                                memberInfo["isReadOnly"] = isReadOnly
                            }
                        }
                        
                        // 处理方法特有的信息
                        if memberKind.contains("func") {
                            // 获取参数信息
                            var parameters: [[String: Any]] = []
                            if let parameterLists = member["key.elements"] as? [[String: Any]] {
                                for paramList in parameterLists {
                                    if let params = paramList["key.elements"] as? [[String: Any]] {
                                        for param in params {
                                            var paramInfo: [String: Any] = [:]
                                            
                                            if let paramName = param["key.name"] as? String {
                                                paramInfo["name"] = paramName
                                            }
                                            if let paramType = param["key.typename"] as? String {
                                                paramInfo["type"] = paramType
                                            }
                                            if let paramInternalName = param["key.internal_param_name"] as? String {
                                                paramInfo["internalName"] = paramInternalName
                                            }
                                            
                                            parameters.append(paramInfo)
                                        }
                                    }
                                }
                            }
                            
                            if !parameters.isEmpty {
                                memberInfo["parameters"] = parameters
                            }
                            
                            // 获取返回类型
                            if let returnType = member["key.returntype"] as? String {
                                memberInfo["returnType"] = returnType
                            }
                        }
                        
                        // 添加到成员列表
                        uiviewMembers.append(memberInfo)
                    }
                }
            }
            
            break
        }
    }
    
    // 构建最终结果
    var result: [String: Any] = [:]
    
    // 获取基本信息
    if let name = uiviewInfo["key.name"] as? String {
        result["name"] = name
    }
    if let kind = uiviewInfo["key.kind"] as? String {
        result["kind"] = kind
    }
    if let accessibility = uiviewInfo["key.accessibility"] as? String {
        result["accessibility"] = accessibility
    }
    
    // 获取继承层次
    if let inherits = uiviewInfo["key.inheritedtypes"] as? [[String: Any]] {
        var inheritedTypes: [String] = []
        for type in inherits {
            if let typeName = type["key.name"] as? String {
                inheritedTypes.append(typeName)
            }
        }
        if !inheritedTypes.isEmpty {
            result["inherits"] = inheritedTypes
        }
    }
    
    // 获取可用性信息
    if let attributes = uiviewInfo["key.attributes"] as? [[String: Any]] {
        var availability: [String: Any] = [:]
        for attr in attributes {
            if let attrName = attr["key.attribute"] as? String,
               attrName == "source.decl.attribute.available" {
                if let arguments = attr["key.arguments"] as? [[String: Any]] {
                    for arg in arguments {
                        if let platform = arg["key.name"] as? String,
                           let version = arg["key.value"] as? String {
                            availability[platform] = version
                        }
                    }
                }
            }
        }
        if !availability.isEmpty {
            result["availability"] = availability
        }
    }
    
    // 添加成员信息
    result["members"] = uiviewMembers
    
    return result
}

// 执行分析并输出 JSON
do {
    let uiviewData = try analyzeUIView()
    
    // 转换为 JSON
    let jsonData = try JSONSerialization.data(withJSONObject: uiviewData, options: [.prettyPrinted])
    if let jsonString = String(data: jsonData, encoding: .utf8) {
        print(jsonString)
    }
    
    // 保存为文件
    try jsonData.write(to: URL(fileURLWithPath: "UIView_swift_api.json"))
    print("Swift UIView API 分析结果已保存到 UIView_swift_api.json")
} catch {
    print("错误: \(error)")
}
