import ObjectMapper
import RPC_Common

/**
 * this class is created by Auto, don't modify it!!
 * 用户id
 */
public class UserIdRequest : Mappable {

  /**
   * 状态[ValidEnum]
   */
  public var state: ValidEnum?
  /**
   * 用户id(必传)
   */
  public var userId: Int64?

  public required init?(map: Map) {
  }

  public convenience init?(state: ValidEnum? = nil, userId: Int64? = nil) {
    self.init(JSON: [String: Any]())
    self.state = state
    self.userId = userId
  }

  public func mapping(map: Map) {
    state <- map["state"]
    userId <- (map["userId"], LongTransform())
  }

}
