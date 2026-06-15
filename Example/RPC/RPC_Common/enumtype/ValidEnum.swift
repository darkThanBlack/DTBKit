/**
 * this class is created by Auto, don't modify it!!
 */
public enum ValidEnum : String, CaseIterable {

  case INVALID
  case VALID

}

public extension ValidEnum {
  var localizeString: String {
    switch self {
      case .INVALID:
        return "无效"
      case .VALID:
        return "有效"
    }
  }
}
