/**
 * this class is created by Auto, don't modify it!!
 */
public enum GenderEnum : String, CaseIterable {

  case MAN
  case UNKNOWN
  case WOMEN

}

public extension GenderEnum {
  var localizeString: String {
    switch self {
      case .MAN:
        return "男"
      case .UNKNOWN:
        return "未知"
      case .WOMEN:
        return "女"
    }
  }
}
