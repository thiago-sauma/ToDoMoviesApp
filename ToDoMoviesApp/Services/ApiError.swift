
import Foundation

enum ApiError: LocalizedError {
    case urlError
    case comunicationError(Error)
    case dataError
    case genericError(Int)
    case jsonError
    case error500
    case error401
    
    var errorDescription: String? {
        switch self {
        case .urlError:
            return "URL error"
        case .comunicationError(let error):
            return "API Comunication Error:\(error)"
        case .dataError:
            return "Error retrieving data"
        case .genericError(let error):
            return "HTTP error:\(error)"
        case .jsonError:
            return "Error parsing JSON"
        case .error500:
            return "No permission granted"
        case .error401:
            return "Authentication error"
        }
    }
    
    
}
