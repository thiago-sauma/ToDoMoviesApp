

import Foundation

protocol HomeViewModelDelegate {
    func updateMovieResultsArray(with results: [Movie])
    func updateErrorMessage(with error: ApiError)
}

class HomeViewModel {
    
    var delegate: HomeViewModelDelegate?
    var moviesArray = [Movie]()
    var search: Search
    
    init(search: Search) {
        self.search = search
    }
    
    func fetch(category: Category) {
        search.performSearch(category: category) {  results in
            switch results {
            case .success(let moviesResults):
                self.moviesArray = moviesResults
                self.delegate?.updateMovieResultsArray(with: self.moviesArray)
            case .failure(let error):
                self.delegate?.updateErrorMessage(with: error)
            }
        }
    }
    
    func handleSearchText(searchText: String) {
        var filteredArray: [Movie] = []
        filteredArray = moviesArray.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
        moviesArray = filteredArray
    }
    
    
    
}
