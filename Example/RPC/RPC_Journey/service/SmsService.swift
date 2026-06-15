import Moya

/**
 * this class is created by Auto, don't modify it!!
 */
public enum SmsService {

  /**
   * 发送短信验证码
   * @param request request
   * @return Swift.Any
   */
  case sendVerifyCode(request: SendVerifyCodeRequest?)

}

extension SmsService : TargetType {
  public var path: String {
    switch self {
      case .sendVerifyCode:
        return "/journey/anon/sms/sendVerifyCode"
    }
  }
  public var task: Task {
    switch self {
      case let .sendVerifyCode(request):
        let params: [String: Any] = request?.toJSON() ?? [:]
        return .requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
  }
  public var headers: [String : String]? {
    return ["Content-type": "application/json"]
  }
}
