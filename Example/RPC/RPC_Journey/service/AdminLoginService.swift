import Moya

/**
 * this class is created by Auto, don't modify it!!
 */
public enum AdminLoginService {
    
    /**
     * web端登录
     * @param request request
     * @return RPC_Journey.AdminLoginResultVO
     */
    case loginForApp(request: AdminLoginRequest?)
    
}

extension AdminLoginService : TargetType {
    public var path: String {
        switch self {
        case .loginForApp:
            return "/journey/anon/login/loginForApp"
        }
    }
    public var task: Task {
        switch self {
        case let .loginForApp(request):
            let params: [String: Any] = request?.toJSON() ?? [:]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
}
