import Foundation
import SourceKittenFramework

/// 通用响应解析函数 - 保持不变的部分
func parseClassResponse(response: [String: SourceKitRepresentable], className: String, file: File?) throws -> [String: Any] {
    print("解析响应获取 \(className) 信息...")
    
    var allMembers: [[String: SourceKitRepresentable]] = []
    var classInfo: [String: SourceKitRepresentable]? = nil
    
    // 1. 更全面的递归搜索函数
    func findClassAndMembersRecursively(in dictionary: [String: SourceKitRepresentable], path: String = "root") {
        // 检查当前项是否是目标类或其扩展
        if let name = dictionary["key.name"] as? String,
           name == className {
            print("在路径 \(path) 找到 \(className)")
            
            // 保存类信息（如果还没有的话）
            if classInfo == nil {
                classInfo = dictionary
            }
            
            // 收集成员
            if let substructure = dictionary["key.substructure"] as? [[String: SourceKitRepresentable]] {
                allMembers.append(contentsOf: substructure)
                print("从 \(path) 添加了 \(substructure.count) 个成员")
            }
        }
        
        // 检查特殊情况：扩展内的子结构可能包含目标类的成员
        if let kind = dictionary["key.kind"] as? String,
           kind.contains("extension"),
           let typeName = dictionary["key.typename"] as? String,
           typeName.contains(className) ||
           (dictionary["key.name"] as? String) == className {
            
            print("在路径 \(path) 找到 \(className) 的扩展")
            
            // 收集扩展中的成员
            if let substructure = dictionary["key.substructure"] as? [[String: SourceKitRepresentable]] {
                allMembers.append(contentsOf: substructure)
                print("从扩展添加了 \(substructure.count) 个成员")
            }
        }
        
        // 如果当前项有子结构，递归搜索
        if let substructure = dictionary["key.substructure"] as? [[String: SourceKitRepresentable]] {
            for (index, item) in substructure.enumerated() {
                findClassAndMembersRecursively(in: item, path: "\(path)/[\(index)]")
            }
        }
    }
    
    // 2. 处理顶级结构
    if let substructure = response["key.substructure"] as? [[String: SourceKitRepresentable]] {
        print("找到 \(substructure.count) 个顶级声明")
        
        // 对每个顶级声明应用递归搜索
        for (index, item) in substructure.enumerated() {
            findClassAndMembersRecursively(in: item, path: "[\(index)]")
        }
    }
    
    // 3. 如果找不到成员，尝试直接处理实体
    if allMembers.isEmpty {
        if let entities = response["key.entities"] as? [[String: SourceKitRepresentable]] {
            print("尝试从 \(entities.count) 个实体中查找...")
            for (index, entity) in entities.enumerated() {
                findClassAndMembersRecursively(in: entity, path: "entity[\(index)]")
            }
        }
    }
    
    // 处理成员信息
    print("总共找到 \(allMembers.count) 个成员")
    var processedMembers: [[String: Any]] = []
    let uniqueMemberNames = Set(allMembers.compactMap { $0["key.name"] as? String })
    print("包含 \(uniqueMemberNames.count) 个唯一命名的成员")
    
    // 处理获取到的成员信息
    for member in allMembers {
        if let name = member["key.name"] as? String,
           let kind = member["key.kind"] as? String {
            
            // 检查是否已经处理过同名成员
            if processedMembers.contains(where: { ($0["name"] as? String) == name }) {
                continue // 跳过重复成员
            }
            
            var memberInfo: [String: Any] = [:]
            memberInfo["name"] = name
            memberInfo["kind"] = kind
            
            // 提取类型信息
            if let typeName = member["key.typename"] as? String {
                memberInfo["type"] = typeName
            }
            
            // 获取访问级别（保留所有访问级别，不再过滤）
            if let accessibility = member["key.accessibility"] as? String {
                memberInfo["accessibility"] = accessibility
            }
            
            // 获取 Objective-C 选择器名称
            if let selector = member["key.selector"] as? String {
                memberInfo["selector"] = selector
            }
            
            // 处理属性特性
            if kind.contains("var") || kind.contains("property") {
                // 检查是否是只读属性
                var isReadOnly = false
                
                // Swift 风格检查
                if let accessors = member["key.accessors"] as? [[String: SourceKitRepresentable]] {
                    isReadOnly = accessors.count == 1 &&
                               (accessors[0]["key.accessibility"] as? String == "source.lang.swift.accessibility.internal" ||
                                accessors[0]["key.name"] as? String == "get")
                }
                
                // Objective-C 风格检查
                if let attributes = member["key.attributes"] as? [[String: SourceKitRepresentable]] {
                    for attr in attributes {
                        if let attrName = attr["key.attribute"] as? String, attrName == "readonly" {
                            isReadOnly = true
                            break
                        }
                    }
                }
                
                memberInfo["isReadOnly"] = isReadOnly
            }
            
            // 处理方法参数
            if kind.contains("func") || kind.contains("method") {
                var parameters: [[String: Any]] = []
                
                // 处理 Swift 风格参数
                if let parameterLists = member["key.substructure"] as? [[String: SourceKitRepresentable]] {
                    for param in parameterLists {
                        if param["key.kind"] as? String == "source.lang.swift.decl.var.parameter" {
                            var paramInfo: [String: Any] = [:]
                            
                            if let paramName = param["key.name"] as? String {
                                paramInfo["name"] = paramName
                            }
                            if let paramType = param["key.typename"] as? String {
                                paramInfo["type"] = paramType
                            }
                            
                            parameters.append(paramInfo)
                        }
                    }
                }
                
                if !parameters.isEmpty {
                    memberInfo["parameters"] = parameters
                }
                
                // 获取返回类型
                if let returnType = member["key.typename"] as? String {
                    // 对于 Swift 方法，返回类型通常包含完整函数类型
                    if returnType.contains("->") {
                        if let returnIndex = returnType.range(of: "->") {
                            let returnValue = String(returnType[returnType.index(returnIndex.upperBound, offsetBy: 1)...])
                                .trimmingCharacters(in: .whitespaces)
                            memberInfo["returnType"] = returnValue
                        } else {
                            memberInfo["returnType"] = returnType
                        }
                    } else {
                        memberInfo["returnType"] = returnType
                    }
                }
            }
            
            // 检查可用性（@available）
            if let attributes = member["key.attributes"] as? [[String: SourceKitRepresentable]] {
                var availabilityInfo: [String: Any] = [:]
                
                for attr in attributes {
                    if let attrName = attr["key.attribute"] as? String,
                       attrName == "source.decl.attribute.available" {
                        
                        if let arguments = attr["key.arguments"] as? [[String: SourceKitRepresentable]] {
                            for arg in arguments {
                                if let platform = arg["key.name"] as? String,
                                   let version = arg["key.value"] as? String {
                                    availabilityInfo[platform] = version
                                }
                                
                                // 处理弃用信息
                                if let deprecated = arg["key.deprecated"] as? String {
                                    availabilityInfo["deprecated"] = deprecated
                                }
                                if let message = arg["key.message"] as? String {
                                    availabilityInfo["message"] = message
                                }
                            }
                        }
                    }
                }
                
                if !availabilityInfo.isEmpty {
                    memberInfo["availability"] = availabilityInfo
                }
            }
            
            // 添加到处理后的成员列表
            processedMembers.append(memberInfo)
        }
    }
    
    // 创建最终结果
    var result: [String: Any] = [
        "name": className
    ]
    
    // 设置类型信息（如果有）
    if let classInfo = classInfo, let kind = classInfo["key.kind"] as? String {
        result["kind"] = kind
    } else {
        // 如果没找到明确的类型信息，假定是扩展
        result["kind"] = "source.lang.swift.decl.extension"
    }
    
    // 获取继承信息
    if let classInfo = classInfo {
        // 获取 Swift 继承信息
        if let inherits = classInfo["key.inheritedtypes"] as? [[String: SourceKitRepresentable]] {
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
        
        // 获取 Objective-C 继承信息
        if let inherits = classInfo["key.inheritedtype"] as? [String: SourceKitRepresentable],
           let inheritedName = inherits["key.name"] as? String {
            result["inherits"] = [inheritedName]
        }
    }
    
    // 添加处理后的成员
    result["members"] = processedMembers
    
    return result
}

/// 输出结果到 JSON 文件
func outputResults(result: [String: Any], className: String) {
    do {
        // 输出JSON
        let jsonData = try JSONSerialization.data(withJSONObject: result, options: [.prettyPrinted])
        let outputPath = "\(className)_api.json"
        try jsonData.write(to: URL(fileURLWithPath: outputPath))
        print("分析结果已保存到: \(FileManager.default.currentDirectoryPath)/\(outputPath)")
        
        // 输出一些统计信息
        if let members = result["members"] as? [[String: Any]] {
            print("\n统计信息:")
            print("- 总成员数: \(members.count)")
            
            let properties = members.filter { ($0["kind"] as? String)?.contains("var") == true ||
                                             ($0["kind"] as? String)?.contains("property") == true }
            let methods = members.filter { ($0["kind"] as? String)?.contains("func") == true ||
                                          ($0["kind"] as? String)?.contains("method") == true }
            let readOnlyProps = properties.filter { $0["isReadOnly"] as? Bool == true }
            
            print("- 属性数量: \(properties.count) (其中只读: \(readOnlyProps.count))")
            print("- 方法数量: \(methods.count)")
        }
    } catch {
        print("保存结果失败: \(error)")
    }
}

// 分析指定的 Swift 文件
func analyzeSwiftFile(filePath: String, className: String, sdkPath: String) throws {
    print("分析文件: \(filePath)")
    
    // 检查文件是否存在
    guard FileManager.default.fileExists(atPath: filePath) else {
        throw NSError(domain: "FileNotFound", code: 404,
                      userInfo: [NSLocalizedDescriptionKey: "找不到文件: \(filePath)"])
    }
    
    // 加载文件
    guard let file = File(path: filePath) else {
        throw NSError(domain: "FileError", code: 500,
                     userInfo: [NSLocalizedDescriptionKey: "无法加载文件: \(filePath)"])
    }
    
    // 创建 editorOpen 请求
    let request = Request.editorOpen(file: file)
    
    // 发送请求并获取响应
    print("发送 editorOpen 请求...")
    let response = try request.send()
    print("获取到响应，键: \(response.keys.joined(separator: ", "))")
    
    // 使用通用解析函数处理响应
    let result = try parseClassResponse(response: response, className: className, file: file)
    
    // 使用通用输出函数保存结果
    outputResults(result: result, className: className)
}

// 主函数 - 分析指定路径列表中的 Swift 文件
func jsonCreater() {
    do {
        // 获取 SDK 路径
        let process = Process()
        process.launchPath = "/usr/bin/xcrun"
        process.arguments = ["--show-sdk-path", "--sdk", "iphonesimulator"]
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        process.launch()
        process.waitUntilExit()
        
        guard let sdkPath = String(data: outputPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            print("⚠️ 无法获取 SDK 路径")
            return
        }
        print("SDK路径: \(sdkPath)")
        
        // 指定要分析的 Swift 文件路径列表
        let filePaths = [
            "/Users/admin/Desktop/UIView.swift"
        ]
        
        // 分析每个文件
        for filePath in filePaths {
            do {
                let className = URL(fileURLWithPath: filePath).deletingPathExtension().lastPathComponent
                print("\n===== 开始分析 \(className) =====\n")
                
                // 使用简化的文件解析函数
                try analyzeSwiftFile(filePath: filePath, className: className, sdkPath: sdkPath)
                
                print("\n===== \(className) 分析完成 =====\n")
            } catch {
                print("分析文件 \(filePath) 失败: \(error)")
            }
        }
    } catch {
        print("初始化失败: \(error)")
    }
}

// 执行 json 解析
// jsonCreater()

//MARK: -

/// 链式 API 生成器
struct ChainAPIGenerator {
    let jsonPath: String
    let outputPath: String
    let templatePath: String? // 可选的模板目录路径
    
    // 主要生成流程
    func generate() throws {
        // 1. 加载和解析 JSON
        let classInfo = try loadAndParseJSON(from: jsonPath)
        
        // 2. 处理和标准化数据
        let processedInfo = try processClassInfo(classInfo)
        
        // 3. 生成代码
        let code = try generateCode(from: processedInfo)
        
        // 4. 写入文件
        try writeToFile(code: code, path: outputPath)
        
        print("🎉 成功生成链式 API！写入文件: \(outputPath)")
    }
    
    // MARK: - 阶段 1: JSON 加载和解析
    
    func loadAndParseJSON(from path: String) throws -> [String: Any] {
        print("📂 从 \(path) 加载JSON")
        
        guard let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            throw GeneratorError.fileNotFound(path: path)
        }
        
        guard let classInfo = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            throw GeneratorError.invalidJSON(path: path)
        }
        
        print("✅ 成功加载JSON")
        return classInfo
    }
    
    // MARK: - 阶段 2: 数据处理和标准化
    
    func processClassInfo(_ classInfo: [String: Any]) throws -> ProcessedClassInfo {
        print("🔄 处理类信息")
        
        guard let className = classInfo["name"] as? String else {
            throw GeneratorError.missingClassName
        }
        
        guard let members = classInfo["members"] as? [[String: Any]] else {
            throw GeneratorError.missingMembers
        }
        
        // 去重处理
        let uniqueMembers = removeDuplicateMembers(members)
        print("🔍 去除重复后剩余 \(uniqueMembers.count) 个成员")
        
        // 分类处理
        let properties = filterProperties(uniqueMembers)
        let methods = filterMethods(uniqueMembers)
        let eligibleProperties = filterEligibleProperties(properties)
        let eligibleMethods = filterEligibleMethods(methods)
        
        print("📊 分类统计:")
        print("  - 属性: \(properties.count) (符合条件: \(eligibleProperties.count))")
        print("  - 方法: \(methods.count) (符合条件: \(eligibleMethods.count))")
        
        return ProcessedClassInfo(
            className: className,
            allMembers: uniqueMembers,
            properties: properties,
            methods: methods,
            eligibleProperties: eligibleProperties,
            eligibleMethods: eligibleMethods,
            inherits: classInfo["inherits"] as? [String]
        )
    }
    
    // 去除重复成员
    func removeDuplicateMembers(_ members: [[String: Any]]) -> [[String: Any]] {
        var uniqueMembers = [[String: Any]]()
        var seenNames = Set<String>()
        
        for member in members {
            if let name = member["name"] as? String {
                if !seenNames.contains(name) {
                    seenNames.insert(name)
                    uniqueMembers.append(member)
                }
            }
        }
        
        return uniqueMembers
    }
    
    // 过滤属性
    func filterProperties(_ members: [[String: Any]]) -> [[String: Any]] {
        return members.filter { member in
            guard let kind = member["kind"] as? String else { return false }
            return kind.contains("var") || kind.contains("property")
        }
    }
    
    // 过滤方法
    func filterMethods(_ members: [[String: Any]]) -> [[String: Any]] {
        return members.filter { member in
            guard let kind = member["kind"] as? String else { return false }
            return kind.contains("func") || kind.contains("method")
        }
    }
    
    // 改进后的属性筛选函数
    func filterEligibleProperties(_ properties: [[String: Any]]) -> [[String: Any]] {
        return properties.filter { property in
            // 检查是否是公开成员
            let isPublic = isPublicMember(property)
            // 检查是否是只读属性
            let isReadOnly = property["isReadOnly"] as? Bool == true
            
            // 公开的属性中:
            // - 可写属性可以直接生成链式API
            // - 只读属性只有在是复杂类型时才生成处理器模式API
            return isPublic && (!isReadOnly || isComplexType(property))
        }
    }
    
    // 筛选适合链式调用的方法
    func filterEligibleMethods(_ methods: [[String: Any]]) -> [[String: Any]] {
        return methods.filter { method in
            // 筛选公开且适合链式调用的方法
            let isPublic = isPublicMember(method)
            let isInitializer = (method["name"] as? String)?.hasPrefix("init") == true
            return isPublic && !isInitializer
        }
    }
    
    // 检查成员是否公开
    func isPublicMember(_ member: [String: Any]) -> Bool {
        guard let accessibility = member["accessibility"] as? String else {
            return false
        }
        return accessibility.contains("public") || accessibility.contains("open")
    }
    
    // 检查属性是否为复杂类型（需要嵌套链式调用）
    func isComplexType(_ property: [String: Any]) -> Bool {
        guard let type = property["type"] as? String else { return false }
        
        // 检查是否是常见的复杂UI类型
        let complexTypes = ["UIView", "CALayer", "UIColor", "UIFont", "UIImage",
                           "CGRect", "CGPoint", "CGSize", "UIEdgeInsets"]
        
        for complexType in complexTypes {
            if type.contains(complexType) {
                return true
            }
        }
        
        return false
    }
    
    // MARK: - 阶段 3: 代码生成
    
    func generateCode(from classInfo: ProcessedClassInfo) throws -> String {
        print("💻 生成链式 API 代码")
        
        var code = generateHeader(for: classInfo)
        
        // 生成属性链式 API
        for property in classInfo.eligibleProperties {
            code += try generatePropertyChain(property)
        }
        
        // 生成方法链式 API
        for method in classInfo.eligibleMethods {
            if let methodCode = try? generateMethodChain(method) {
                code += methodCode
            }
        }
        
        code += generateFooter()
        
        print("✅ 代码生成完成")
        return code
    }
    
    // 生成头部代码
    func generateHeader(for classInfo: ProcessedClassInfo) -> String {
        let className = classInfo.className
        
        return """
        // 自动生成的 DTBKit 链式 API 扩展
        // 生成于: \(Date())
        
        import UIKit
        import DTBKit
        
        // MARK: - \(className) 链式 API 扩展
        extension Wrapper where Base: \(className) {
        
        """
    }
    
    // 改进后的属性链式API生成函数
    func generatePropertyChain(_ property: [String: Any]) throws -> String {
        guard let name = property["name"] as? String else {
            throw GeneratorError.missingPropertyName
        }
        
        guard let type = property["type"] as? String else {
            throw GeneratorError.missingPropertyType(name: name)
        }
        
        let isReadOnly = property["isReadOnly"] as? Bool == true
        
        // 处理可用性注解
        var availabilityPrefix = ""
        if let availability = property["availability"] as? [String: Any] {
            availabilityPrefix = generateAvailabilityAnnotation(availability)
        }
        
        if isReadOnly {
            if isComplexType(property) {
                // 只读复杂类型 - 使用处理器模式
                return """
                \(availabilityPrefix)
                @inline(__always)
                @discardableResult
                public func \(name)(_ handler: ((Wrapper<\(type)>) -> Void)?) -> Self {
                    if let sv = me.\(name) {
                        handler?(sv.dtb)
                    }
                    return self
                }
                
                """
            } else {
                // 只读简单类型 - 使用值处理器模式
                return """
                \(availabilityPrefix)
                @inline(__always)
                @discardableResult
                public func \(name)(_ handler: ((\(type)) -> Void)?) -> Self {
                    handler?(me.\(name))
                    return self
                }
                
                """
            }
        } else {
            // 可写属性 - 标准链式调用
            return """
            \(availabilityPrefix)
            @inline(__always)
            @discardableResult
            public func \(name)(_ value: \(type)) -> Self {
                me.\(name) = value
                return self
            }
            
            """
        }
    }
    
    // 生成方法链式 API
    func generateMethodChain(_ method: [String: Any]) throws -> String {
        guard let name = method["name"] as? String else {
            throw GeneratorError.missingMethodName
        }
        
        // 处理Swift方法名格式
        let methodName = processSwiftMethodName(name)
        
        // 提取参数
        var parameters = [(label: String, name: String, type: String)]()
        if let methodParams = method["parameters"] as? [[String: Any]] {
            for (index, param) in methodParams.enumerated() {
                guard let paramName = param["name"] as? String,
                      let paramType = param["type"] as? String else {
                    continue
                }
                
                // 处理参数标签
                let paramLabel = extractParamLabel(from: methodName, paramName: paramName, at: index)
                parameters.append((label: paramLabel, name: paramName, type: paramType))
            }
        }
        
        // 处理可用性注解
        var availabilityPrefix = ""
        if let availability = method["availability"] as? [String: Any] {
            availabilityPrefix = generateAvailabilityAnnotation(availability)
        }
        
        // 生成参数声明列表
        let paramDeclarations = parameters.map { param -> String in
            if param.label == "_" || param.label.isEmpty {
                // 无标签参数
                return "\(param.name): \(param.type)"
            } else {
                // 有标签参数
                return "\(param.label) \(param.name): \(param.type)"
            }
        }.joined(separator: ", ")
        
        // 生成方法调用参数
        let callParams = parameters.map { param -> String in
            if param.label == "_" || param.label.isEmpty {
                return param.name
            } else {
                return "\(param.label): \(param.name)"
            }
        }.joined(separator: ", ")
        
        // 处理返回类型
        let returnType = method["returnType"] as? String
        
        // 生成方法名（去掉参数标签部分）
        let funcName = extractBaseFunctionName(methodName)
        
        // 如果有返回值，使用返回值处理器模式
        if let returnType = returnType, returnType != "Void" && returnType != "()" {
            return """
            \(availabilityPrefix)
            @inline(__always)
            @discardableResult
            public func \(funcName)(\(paramDeclarations), handler: ((\(returnType)) -> Void)? = nil) -> Self {
                let result = me.\(methodName)(\(callParams))
                handler?(result)
                return self
            }
            
            """
        } else {
            // 无返回值方法
            return """
            \(availabilityPrefix)
            @inline(__always)
            @discardableResult
            public func \(funcName)(\(paramDeclarations)) -> Self {
                me.\(methodName)(\(callParams))
                return self
            }
            
            """
        }
    }

    // 辅助函数：处理Swift方法名
    func processSwiftMethodName(_ name: String) -> String {
        // 去除末尾的圆括号和参数标签格式，如 "insertSubview(_:at:)"
        if let parenRange = name.range(of: "(") {
            return String(name[..<parenRange.lowerBound])
        }
        return name
    }

    // 辅助函数：提取基础函数名（不包含参数标签）
    func extractBaseFunctionName(_ methodName: String) -> String {
        // 如果有参数标签部分如 "insertSubview(_:at:)"，提取 "insertSubview"
        let components = methodName.components(separatedBy: "(")
        return components[0]
    }

    // 辅助函数：从方法名中提取参数标签
    func extractParamLabel(from methodName: String, paramName: String, at index: Int) -> String {
        // 如果方法名是 "insertSubview(_:at:)" 这种格式，尝试提取参数标签
        if methodName.contains("(") && methodName.contains(":") {
            let pattern = "\\(([^)]+)\\)"
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: methodName, range: NSRange(methodName.startIndex..., in: methodName)) {
                
                if let labelsPart = Range(match.range(at: 1), in: methodName) {
                    let labels = methodName[labelsPart].components(separatedBy: ":")
                    if index < labels.count {
                        let label = labels[index].trimmingCharacters(in: .whitespaces)
                        return label == "_" ? "" : label
                    }
                }
            }
        }
        
        // 对于第一个参数，通常使用 "_" 作为默认标签
        if index == 0 {
            return "_"
        }
        
        // 默认使用参数名作为标签
        return paramName
    }
    
    // 生成可用性注解
    func generateAvailabilityAnnotation(_ availability: [String: Any]) -> String {
        var annotations = [String]()
        
        // 处理 iOS 可用性
        if let ios = availability["iOS"] as? String {
            annotations.append("iOS \(ios)")
        }
        
        // 处理 macOS 可用性
        if let macos = availability["macOS"] as? String {
            annotations.append("macOS \(macos)")
        }
        
        // 处理 tvOS 可用性
        if let tvos = availability["tvOS"] as? String {
            annotations.append("tvOS \(tvos)")
        }
        
        // 处理弃用
        if let deprecated = availability["deprecated"] as? Bool, deprecated {
            annotations.append("deprecated")
        }
        
        if let message = availability["message"] as? String {
            annotations.append("message: \"\(message)\"")
        }
        
        if annotations.isEmpty {
            return ""
        }
        
        return "@available(\(annotations.joined(separator: ", ")))\n"
    }
    
    // 生成尾部代码
    func generateFooter() -> String {
        return """
        }
        """
    }
    
    // MARK: - 阶段 4: 文件写入
    
    func writeToFile(code: String, path: String) throws {
        print("💾 写入文件: \(path)")
        try code.write(toFile: path, atomically: true, encoding: .utf8)
    }
}

// MARK: - 数据结构

/// 处理后的类信息
struct ProcessedClassInfo {
    let className: String
    let allMembers: [[String: Any]]
    let properties: [[String: Any]]
    let methods: [[String: Any]]
    let eligibleProperties: [[String: Any]]
    let eligibleMethods: [[String: Any]]
    let inherits: [String]?
}

// MARK: - 错误处理

/// 生成器错误类型
enum GeneratorError: Error, CustomStringConvertible {
    case fileNotFound(path: String)
    case invalidJSON(path: String)
    case missingClassName
    case missingMembers
    case missingPropertyName
    case missingPropertyType(name: String)
    case missingMethodName
    
    var description: String {
        switch self {
        case .fileNotFound(let path):
            return "找不到文件: \(path)"
        case .invalidJSON(let path):
            return "无效的JSON格式: \(path)"
        case .missingClassName:
            return "JSON中缺少类名"
        case .missingMembers:
            return "JSON中缺少成员列表"
        case .missingPropertyName:
            return "属性缺少名称"
        case .missingPropertyType(let name):
            return "属性 \(name) 缺少类型信息"
        case .missingMethodName:
            return "方法缺少名称"
        }
    }
}

// MARK: - 主函数

/// 主函数示例
func main() {
    do {
        // 指定要分析的 Swift 文件路径列表
        let filePaths = [
            "/Users/admin/Desktop/UIView.swift"
        ]
        
        // 分析每个文件
        for filePath in filePaths {
            let className = URL(fileURLWithPath: filePath).deletingPathExtension().lastPathComponent
            let jsonPath = "\(className)_api.json"
            let outputPath = "\(className)+DTBKit.swift"
            
            let generator = ChainAPIGenerator(jsonPath: jsonPath, outputPath: outputPath, templatePath: nil)
            try generator.generate()
        }
    } catch {
        print("❌ 错误: \(error)")
    }
}

// 执行主函数
 main()
