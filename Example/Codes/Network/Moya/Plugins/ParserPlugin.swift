//
//  ParserPlugin.swift
//  DTBKit
//
//  Created by moonShadow on 2024/1/16
//
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//


import Moya

class ParserPlugin: PluginType {
    
    ///
    func process(_ result: Swift.Result<Response, MoyaError>, target: TargetType) -> Swift.Result<Response, MoyaError> {
        switch result {
        case .success(let response):
            
            /// 其他 HTTP 返回码全部转换成错误对象
            func getError(_ message: String) -> MoyaError {
                return MoyaError.underlying(NSError.dtb.create(message, code: response.statusCode), response)
            }
            
            switch response.statusCode {
            case 200...299, 300...399:
                return result
            case 401:
                // TODO: kick out
                // DTB.user.kickout()
                return .failure(getError(.dtb.create("user.kickout.desc")))
            case 403:
                return .failure(getError(.dtb.create("error.403")))
            case 500:
                return .failure(getError(.dtb.create("error.500")))
            default:
                return .failure(getError(.dtb.create("error.http.code") + "\(response.statusCode)"))
            }
        case .failure(_):
            return result
        }
    }
    
}
