import ObjectMapper
import RPC_Common

/**
 * this class is created by Auto, don't modify it!!
 * 员工信息
 */
public class UserInstAdminVO : Mappable {

  /**
   * 员工姓名
   */
  public var adminName: String?
  /**
   * 头像
   */
  public var avatar: String?
  /**
   * 是否是主账号
   */
  public var boss: Bool?
  /**
   * 创建时间
   */
  public var created: Int64?
  /**
   * 性别[GenderEnum]
   */
  public var gender: GenderEnum?
  /**
   * 员工ID
   */
  public var id: Int64?
  /**
   * 校区ID
   */
  public var instId: Int64?
  /**
   * 校区名称
   */
  public var instName: String?
  /**
   * 最近登陆时间戳
   */
  public var lastLogin: Int64?
  /**
   * 备注
   */
  public var memo: String?
  /**
   * 昵称
   */
  public var nickName: String?
  /**
   * 员工手机号
   */
  public var phone: String?
  /**
   * 状态[ValidEnum]
   */
  public var state: ValidEnum?
  /**
   * 更新时间
   */
  public var updated: Int64?
  /**
   * 关联用户ID
   */
  public var userId: Int64?

  public required init?(map: Map) {
  }

  public convenience init?(
    adminName: String? = nil,
    avatar: String? = nil,
    boss: Bool? = nil,
    created: Int64? = nil,
    gender: GenderEnum? = nil,
    id: Int64? = nil,
    instId: Int64? = nil,
    instName: String? = nil,
    lastLogin: Int64? = nil,
    memo: String? = nil,
    nickName: String? = nil,
    phone: String? = nil,
    state: ValidEnum? = nil,
    updated: Int64? = nil,
    userId: Int64? = nil
  ) {
    self.init(JSON: [String: Any]())
    self.adminName = adminName
    self.avatar = avatar
    self.boss = boss
    self.created = created
    self.gender = gender
    self.id = id
    self.instId = instId
    self.instName = instName
    self.lastLogin = lastLogin
    self.memo = memo
    self.nickName = nickName
    self.phone = phone
    self.state = state
    self.updated = updated
    self.userId = userId
  }

  public func mapping(map: Map) {
    adminName <- map["adminName"]
    avatar <- map["avatar"]
    boss <- map["boss"]
    created <- (map["created"], LongTransform())
    gender <- map["gender"]
    id <- (map["id"], LongTransform())
    instId <- (map["instId"], LongTransform())
    instName <- map["instName"]
    lastLogin <- (map["lastLogin"], LongTransform())
    memo <- map["memo"]
    nickName <- map["nickName"]
    phone <- map["phone"]
    state <- map["state"]
    updated <- (map["updated"], LongTransform())
    userId <- (map["userId"], LongTransform())
  }

}
