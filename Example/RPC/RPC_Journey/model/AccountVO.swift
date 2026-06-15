import ObjectMapper
import RPC_Common

/**
 * this class is created by Auto, don't modify it!!
 * 账户信息
 */
public class AccountVO : Mappable {

  /**
   * 创建时间
   */
  public var created: Int64?
  /**
   * 业务域
   */
  public var domain: String?
  /**
   * 账户id
   */
  public var id: Int64?
  /**
   * 标识(手机号 邮箱 用户名 或第三方应用唯一标识)
   */
  public var identifier: String?
  /**
   * 登录类型(1:手机号 2:邮箱 3:用户名 以及第三方应用)[IdentityTypeEnum]
   */
  public var identityType: IdentityTypeEnum?
  /**
   * 绑定状态 1有效 0冻结 -1失效 （注销用户的帐号另存表）[ValidEnum]
   */
  public var state: ValidEnum?
  /**
   * 更新时间
   */
  public var updated: Int64?
  /**
   * 用户id
   */
  public var userId: Int64?

  public required init?(map: Map) {
  }

  public convenience init?(
    created: Int64? = nil,
    domain: String? = nil,
    id: Int64? = nil,
    identifier: String? = nil,
    identityType: IdentityTypeEnum? = nil,
    state: ValidEnum? = nil,
    updated: Int64? = nil,
    userId: Int64? = nil
  ) {
    self.init(JSON: [String: Any]())
    self.created = created
    self.domain = domain
    self.id = id
    self.identifier = identifier
    self.identityType = identityType
    self.state = state
    self.updated = updated
    self.userId = userId
  }

  public func mapping(map: Map) {
    created <- (map["created"], LongTransform())
    domain <- map["domain"]
    id <- (map["id"], LongTransform())
    identifier <- map["identifier"]
    identityType <- map["identityType"]
    state <- map["state"]
    updated <- (map["updated"], LongTransform())
    userId <- (map["userId"], LongTransform())
  }

}
