import Foundation

protocol HomeViewModelDelegate {
    func searchStatusDidUpdate(statusDidChangeTo status: SearchStatus)
}

class HomeViewModel {
    
    var delegate: HomeViewModelDelegate?
    private (set) var moviesArray = [Movie]()
    private (set) var search: Search
    
    private (set) var searchStatus: SearchStatus = .loading {
        didSet {
            delegate?.searchStatusDidUpdate(statusDidChangeTo: searchStatus)
        }
    }
    
    init(search: Search) {
        self.search = search
    }
    
    func fetch(category: Category) {
        searchStatus = .loading
        search.performSearch(category: category) {  results in
            switch results {
            case .success(let moviesResults):
                DispatchQueue.main.async {
                    self.moviesArray = moviesResults
                    self.searchStatus = .success
            }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.searchStatus = .error(error)
                }
            }
        }
    }
    
    func handleSearchText(searchText: String) {
        var filteredArray: [Movie] = []
        filteredArray = moviesArray.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
        moviesArray = filteredArray
        if moviesArray.isEmpty {
            searchStatus = .noResults
        }
    }
    
    
    
}
