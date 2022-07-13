

import UIKit

struct Search {
    
    private func getURL(for category: Category) -> URL? {
        var endpoint: String
        switch category {
        case .popular:
            endpoint = EndPoint.popular.name
        case .upcoming:
            endpoint = EndPoint.upcoming.name
        case .topRated:
            endpoint = EndPoint.topRated.name
        case .nowPlaying:
            endpoint = EndPoint.nowPlaying.name
        }
        guard let url = URL(string: endpoint) else { return nil }
        return url
    }
    
    private func parseData(data: Data) -> [Movie]? {
        let jsonDecoder = JSONDecoder()
        do {
            let resultsArray = try jsonDecoder.decode(MoviesResults.self, from: data)
            return resultsArray.results
        } catch {
            return nil
        }
    }
    
    func performSearch(category: Category, completion: @escaping (Result<[Movie], ApiError>) -> Void) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: getURL(for: category)!) { data, response, error in
            if  let error = error {
                completion(.failure(.comunicationError(error)))
                return
            }
            if let response = response as? HTTPURLResponse,
               case 200...299 = response.statusCode {
                if let data = data {
                    if let results = parseData(data: data){
                        completion(.success(results))
                    }
                    completion(.failure(.jsonError))
                }
                completion(.failure(.dataError))
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
