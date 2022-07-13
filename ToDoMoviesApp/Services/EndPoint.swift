
import Foundation

enum EndPoint: String {
    case popular
    case upcoming
    case topRated
    case nowPlaying
    
    var name: String {
        if case .popular = self {
            return "https://api.themoviedb.org/3/movie/popular?api_key=b5c5db7a09a995c8269a97947cef3552&language=en-US&page=1"
        }
        if case .upcoming = self {
            return "https://api.themoviedb.org/3/movie/upcoming?api_key=b5c5db7a09a995c8269a97947cef3552&language=en-US&page=1"
        }
        
        if case .topRated = self {
            return "https://api.themoviedb.org/3/movie/top_rated?api_key=b5c5db7a09a995c8269a97947cef3552&language=en-US&page=1"
        }
        
        if case .nowPlaying = self {
            return "https://api.themoviedb.org/3/movie/now_playing?api_key=b5c5db7a09a995c8269a97947cef3552&language=en-US&page=1"
        }
        
            
        return String()
    }
}
