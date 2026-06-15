/**
 * this class is created by Auto, don't modify it!!
 */
public enum LoginTypeEnum : String, CaseIterable {

  case PASSWORD
  case SMS

}

public extension LoginTypeEnum {
  var localizeString: String {
    switch self {
      case .PASSWORD:
        return "密码"
      case .SMS:
        return "短信验证码"
    }
  }
}
