import Foundation

protocol HomeViewModelDelegate {
    func searchStatusDidUpdate(statusDidChangeTo status: SearchStatus)
}

class HomeViewModel {
    
    var delegate: HomeViewModelDelegate?
    private var currentPage = 1
    var moviesArray = [Movie]()
    private (set) var search: Search
    private (set) var isLoadingMore = false
    
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
        let pageRequest = moviesArray.count == 0 ? currentPage : currentPage + 1
        search.performSearch(category: category, page: pageRequest) {  results in
            switch results {
            case .success(let moviesResults):
                let newResults = moviesResults.results
                self.moviesArray.append(contentsOf: newResults)
                self.currentPage = moviesResults.page
                self.isLoadingMore = false
                DispatchQueue.main.async {
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
