import Foundation

enum ApiError: LocalizedError {
    case urlError
    case comunicationError
    case genericError(Int)
    case error500
    case error401
    
    var errorDescription: String? {
        switch self {
        case .urlError:
            return "URL error"
        case .comunicationError:
            return "No Internet Access"
        case .genericError(let error):
            return "HTTP error:\(error)"
        case .error500:
            return "No permission granted"
        case .error401:
            return "Authentication error"
        }
    }
    
    
}
