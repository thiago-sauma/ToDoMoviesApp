

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
            print("error decoding json")
            return nil
        }
    }
    
    func performSearch(category: Category, completion: @escaping (([Movie]) -> Void)) {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: getURL(for: category)!) { data, response, error in
            guard error == nil else {
                print("networking error")
                return
            }
            if let response = response as? HTTPURLResponse,
               case 200...299 = response.statusCode {
                if let data = data {
                    if let results = parseData(data: data){
                        completion(results)
                    }
                }
            }
        }
        dataTask.resume()
    }
}
