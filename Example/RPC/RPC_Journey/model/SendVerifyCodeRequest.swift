import ObjectMapper

/**
 * this class is created by Auto, don't modify it!!
 * 发送验证码请求
 */
public class SendVerifyCodeRequest : Mappable {

  /**
   * 手机号(必传)
   */
  public var phone: String?
  /**
   * 业务类型(必传)
   */
  public var serverType: String?

  public required init?(map: Map) {
  }

  public convenience init?(phone: String? = nil, serverType: String? = nil) {
    self.init(JSON: [String: Any]())
    self.phone = phone
    self.serverType = serverType
  }

  public func mapping(map: Map) {
    phone <- map["phone"]
    serverType <- map["serverType"]
  }

}
