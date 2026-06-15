import ObjectMapper
import RPC_Common

/**
 * this class is created by Auto, don't modify it!!
 * web登录参数请求
 */
public class AdminLoginRequest : Mappable {

  /**
   * 登录账号
   */
  public var accountNo: String?
  /**
   * 登录凭证(密码或者验证码或者微信登录授权码)
   */
  public var certificate: String?
  /**
   * 登录方式[LoginTypeEnum]
   */
  public var loginType: LoginTypeEnum?

  public required init?(map: Map) {
  }

  public convenience init?(
    accountNo: String? = nil,
    certificate: String? = nil,
    loginType: LoginTypeEnum? = nil
  ) {
    self.init(JSON: [String: Any]())
    self.accountNo = accountNo
    self.certificate = certificate
    self.loginType = loginType
  }

  public func mapping(map: Map) {
    accountNo <- map["accountNo"]
    certificate <- map["certificate"]
    loginType <- map["loginType"]
  }

}
