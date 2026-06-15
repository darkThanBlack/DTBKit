//
//  VerifyCodeViewModel.swift
//  XMSport
//
//  Created by moonShadow on 2024/2/1
//  Copyright © 2024 jiejing. All rights reserved.
//
//  LICENSE: SAME AS REPOSITORY
//  Contact me: [GitHub](https://github.com/darkThanBlack)
//




import Moya
import RxSwift
import PromiseKit

/// 验证码登录
class VerifyCodeViewModel: LoginViewModel {
    
//    /// 执行验证码登录
//    func fireSmsLogin(with phone: String, code: String) -> Promise<Void> {
//        return querySmsLogin(with: phone, code: code)
//            .then {
//                return DTB.user.changeStudio(bizCode: .login(phone: phone), toAdminId: nil, toStudioId: nil)
//            }
//    }
//    
//    /// 验证码登录接口
//    private func querySmsLogin(with phone: String, code: String) -> Promise<Void> {
//        let params = LoginRequest(
//            accountNo: phone,
//            certificate: code,
//            loginMode: .PHONE_AUTH_CODE,
//            loginTerm: .FITNESS_ADMIN_APP,
//            serverType: DTB.serverType
//        )
//        let request = MultiTarget(LoginService.loginAdmin(request: params))
//        return Promise { seal in
//            /// 在外层 clear user
//            func errorHandler(_ message: String?) {
//                seal.reject(NSError.dtb.create(message))
//            }
//            
//            let _ = provider.rx
//                .makeRequest(request, autoAnimate: false, autoError: false)
//                .mapObject(type: LoginResultVO.self)
//                .subscribe { result in
//                    guard let token = result.authToken, token.isEmpty == false else {
//                        errorHandler("token" + .dtb.create("error.required"))
//                        return
//                    }
//                    guard let userId = result.userId?.dtb.string().value, userId.isEmpty == false else {
//                        errorHandler("userId" + .dtb.create("error.required"))
//                        return
//                    }
//                    guard let domain = result.domain, domain.isEmpty == false else {
//                        errorHandler("domain" + .dtb.create("error.required"))
//                        return
//                    }
//                    
//                    // 需要先存储到本地用于请求头公有参数填充, 如果后续报错再清除
//                    DTB.user.save { model in
//                        model?.userId = userId
//                        model?.token = token
//                        model?.domain = domain
//                    }
//                    
//                    seal.fulfill(())
//                } onError: { error in
//                    errorHandler(error.localizedDescription)
//                }
//        }
//    }
    
}
