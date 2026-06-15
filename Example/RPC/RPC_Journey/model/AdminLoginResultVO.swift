import ObjectMapper
import RPC_Common

/**
 * this class is created by Auto, don't modify it!!
 * 小程序登录返回结果
 */
public class AdminLoginResultVO : Mappable {

  /**
   * 帐号Id
   */
  public var accountId: Int64?
  /**
   * 该用户的所有账号
   */
  public var accountVOList: [AccountVO]?
  /**
   * 授权token
   */
  public var authToken: String?
  /**
   * 是否已绑定电话
   */
  public var bindPhone: Bool?
  /**
   * 业务域
   */
  public var domain: String?
  /**
   * 帐号
   */
  public var identifier: String?
  /**
   * 帐号类型[IdentityTypeEnum]
   */
  public var identityType: IdentityTypeEnum?
  /**
   * 是否为初始密码登录
   */
  public var isInitialPassword: Bool?
  /**
   * 登录端位
   */
  public var loginTerm: String?
  /**
   * 用户昵称
   */
  public var nickName: String?
  /**
   * 小程序appId
   */
  public var openId: String?
  /**
   * 手机号
   */
  public var phone: String?
  /**
   * 续租时间（秒）
   */
  public var renewExpireSeconds: Int64?
  /**
   * 用户Id
   */
  public var userId: Int64?

  public required init?(map: Map) {
  }

  public convenience init?(
    accountId: Int64? = nil,
    accountVOList: [AccountVO]? = nil,
    authToken: String? = nil,
    bindPhone: Bool? = nil,
    domain: String? = nil,
    identifier: String? = nil,
    identityType: IdentityTypeEnum? = nil,
    isInitialPassword: Bool? = nil,
    loginTerm: String? = nil,
    nickName: String? = nil,
    openId: String? = nil,
    phone: String? = nil,
    renewExpireSeconds: Int64? = nil,
    userId: Int64? = nil
  ) {
    self.init(JSON: [String: Any]())
    self.accountId = accountId
    self.accountVOList = accountVOList
    self.authToken = authToken
    self.bindPhone = bindPhone
    self.domain = domain
    self.identifier = identifier
    self.identityType = identityType
    self.isInitialPassword = isInitialPassword
    self.loginTerm = loginTerm
    self.nickName = nickName
    self.openId = openId
    self.phone = phone
    self.renewExpireSeconds = renewExpireSeconds
    self.userId = userId
  }

  public func mapping(map: Map) {
    accountId <- (map["accountId"], LongTransform())
    accountVOList <- map["accountVOList"]
    authToken <- map["authToken"]
    bindPhone <- map["bindPhone"]
    domain <- map["domain"]
    identifier <- map["identifier"]
    identityType <- map["identityType"]
    isInitialPassword <- map["isInitialPassword"]
    loginTerm <- map["loginTerm"]
    nickName <- map["nickName"]
    openId <- map["openId"]
    phone <- map["phone"]
    renewExpireSeconds <- (map["renewExpireSeconds"], LongTransform())
    userId <- (map["userId"], LongTransform())
  }

}
