

import UIKit

struct Search {
    
    
    private func getURL(for category: Category, page: Int) -> URL? {
        let endpoint: String = getEndPoint(category: category, for: page)
        guard let url = URL(string: endpoint) else { return nil }
        return url
    }
    
    private func getEndPoint(category: Category, for page: Int)-> String {
        switch category {
        case .popular:
            return "https://api.themoviedb.org/3/movie/popular?api_key=b5c5db7a09a995c8269a97947cef3552&language=en-US&page=\(page)"
        case .upcoming:
            return "https://api.themoviedb.org/3/movie/upcoming?api_key=b5c5db7a09a995c8269a97947cef3552&language=en-US&page=\(page)"
        case .topRated:
            return "https://api.themoviedb.org/3/movie/top_rated?api_key=b5c5db7a09a995c8269a97947cef3552&language=en-US&page=\(page)"
        case .nowPlaying:
            return "https://api.themoviedb.org/3/movie/now_playing?api_key=b5c5db7a09a995c8269a97947cef3552&language=en-US&page=\(page)"
        }
    }
    
    private func parseData(data: Data) -> MoviesResults? {
        let jsonDecoder = JSONDecoder()
        do {
            let resultsArray = try jsonDecoder.decode(MoviesResults.self, from: data)
            return resultsArray
        } catch {
            return nil
        }
    }
    
    func performSearch(category: Category, page: Int, completion: @escaping (Result< MoviesResults, ApiError>) -> Void) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: getURL(for: category, page: page)!) { data, response, error in
            if  error != nil {
                completion(.failure(.comunicationError))
                return
            }
            if let response = response as? HTTPURLResponse,
               case 200...299 = response.statusCode {
                if let data = data {
                    if let results = parseData(data: data){
                        completion(.success(results))
                    }
                }
            }
            handleHttpError(response: response) { error in
                completion(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    private func handleHttpError(response: URLResponse?, completion: @escaping ((ApiError) -> Void)) {
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200:
                break
            case 401:
                completion(.error401)
            case 500:
                completion(.error500)
            default:
                completion(.genericError(httpResponse.statusCode))
            }
        }
    }
}
