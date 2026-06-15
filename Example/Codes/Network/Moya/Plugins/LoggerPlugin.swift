//
//  LoggerPlugin.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/16
//  
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//
    

import Moya

/// TODO: 控制台 / 浮窗日志处理
class LoggerPlugin: PluginType {
    
    private let dateFormatString = "mm:ss.SSS"
    private let dateFormatter = DateFormatter()
    private var date: String {
        dateFormatter.dateFormat = dateFormatString
        dateFormatter.locale = Locale(identifier: "zh_CN")
        return dateFormatter.string(from: Date())
    }
    
    public func willSend(_ request: RequestType, target: TargetType) {
        var log = "\n\n************************* Request Start **********************************\n\n"
        log.append("Date: \(date)\n\n")
        log.append("Http URL: \n\n\(String(describing: request.request?.url?.absoluteString ?? ""))\n\n")
        log.append("Http Method: \n\n\(String(describing: request.request?.httpMethod ?? ""))")

        let headers = request.request?.allHTTPHeaderFields?.description ?? ""
        log.append("\n\nHttp Header: \n\n\(String(describing: headers))")
        
        var bodyString: String?
        if let body = request.request?.httpBody {
            bodyString = String(data: body, encoding: .utf8)?.removingPercentEncoding
        }
        log.append("\n\nHttp Body: \n\n\(bodyString ?? "")")
        
        log.append("\n\n************************* Request End ************************************\n\n")
        DTB.console.log(log)
    }
    
    public func didReceive(_ result: Swift.Result<Response, MoyaError>, target: TargetType) {
        var log = "\n\n************************* Response Start **********************************\n\n"
        log.append("Date: \(date)\n\n")
        log.append("Path: \(String(describing: target.path))\n\n")
        
        var tmpTarget = target
        if let multiTarget = target as? MultiTarget {
            tmpTarget = multiTarget
        }
        
        var code: String?
        var content: String?
        var traceId: String?
        var err: String?
        
        switch result {
        case .success(let response):
            code = "\(response.statusCode)"
            log.append("Status : \(response.statusCode) \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))\n\n")
            do{
                if false {
                let json = try response.mapJSON()
                    content = "\(json)"
                    log.append("Content: \n\n\(json))\n\n")
                }
            } catch {
                err = "\(error.localizedDescription)"
                log.append("Error: \n\n\(error.localizedDescription)\n\n")
            }
            traceId = "\(response.response?.allHeaderFields["traceId"] ?? response.response?.allHeaderFields["traceid"] ?? "")"
            log.append("TraceId: \(traceId ?? "")")
        case .failure(let error):
            err = "\(error.localizedDescription)"
            log.append("Error: \n\n\(error.localizedDescription)")
        }
        
        log.append("\n\n************************ Response End ************************************\n\n")
        DTB.console.log(log)
    }
    
}
