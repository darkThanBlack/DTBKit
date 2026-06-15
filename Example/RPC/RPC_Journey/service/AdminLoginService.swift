import Moya

/**
 * this class is created by Auto, don't modify it!!
 */
public enum AdminLoginService {

  /**
   * 根据uid查询用户所在校区管理员账号
   * @param request request
   * @return [RPC_Journey.UserInstAdminVO]
   */
  case getUserInstAdminList(request: UserIdRequest?)
  /**
   * web端登录
   * @param request request
   * @return RPC_Journey.AdminLoginResultVO
   */
  case loginForApp(request: AdminLoginRequest?)
  /**
   * 切换校区
   * @param request request
   * @return Swift.Bool
   */
  case switchInst(request: SwitchInstRequest?)

}

extension AdminLoginService : TargetType {
  public var path: String {
    switch self {
      case .getUserInstAdminList:
        return "/journey/public/login/getUserInstAdminList"
      case .loginForApp:
        return "/journey/anon/login/loginForApp"
      case .switchInst:
        return "/journey/public/login/switchInst"
    }
  }
  public var task: Task {
    switch self {
      case let .getUserInstAdminList(request):
        let params: [String: Any] = request?.toJSON() ?? [:]
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      case let .loginForApp(request):
        let params: [String: Any] = request?.toJSON() ?? [:]
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
      case let .switchInst(request):
        let params: [String: Any] = request?.toJSON() ?? [:]
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
  }
  public var headers: [String : String]? {
    return ["Content-type": "application/json"]
  }
}
