/**
 * this class is created by Auto, don't modify it!!
 */
public enum IdentityTypeEnum : String, CaseIterable {

  case EMAIL
  case PHONE
  case USERNAME
  case WECHAT_OPEN
  case WECHAT_UNION
  case WECHAT_WORK
  case WECHAT_XCX

}

public extension IdentityTypeEnum {
  var localizeString: String {
    switch self {
      case .EMAIL:
        return "邮箱"
      case .PHONE:
        return "手机号"
      case .USERNAME:
        return "用户名"
      case .WECHAT_OPEN:
        return "微信公众号第三方登录(appId:openId)"
      case .WECHAT_UNION:
        return "微信公众号第三方登录(unionId)"
      case .WECHAT_WORK:
        return "企业微信登录(corpId:openUserId)"
      case .WECHAT_XCX:
        return "微信小程序登录(appId:openId)"
    }
  }
}
