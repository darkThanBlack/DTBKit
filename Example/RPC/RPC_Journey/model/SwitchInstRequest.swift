import ObjectMapper
import RPC_Common

/**
 * this class is created by Auto, don't modify it!!
 * 切换校区请求
 */
public class SwitchInstRequest : Mappable {

  /**
   * 员工Id(必传)
   */
  public var adminId: Int64?
  /**
   * 校区Id(必传)
   */
  public var instId: Int64?

  public required init?(map: Map) {
  }

  public convenience init?(adminId: Int64? = nil, instId: Int64? = nil) {
    self.init(JSON: [String: Any]())
    self.adminId = adminId
    self.instId = instId
  }

  public func mapping(map: Map) {
    adminId <- (map["adminId"], LongTransform())
    instId <- (map["instId"], LongTransform())
  }

}
