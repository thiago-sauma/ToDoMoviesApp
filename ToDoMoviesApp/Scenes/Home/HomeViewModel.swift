import Foundation

protocol HomeViewModelDelegate {
    func searchStatusDidUpdate(statusDidChangeTo status: SearchStatus)
}

class HomeViewModel {
    
    var delegate: HomeViewModelDelegate?
    var isLoadingMore = false
    var moviesArray = [Movie]()
    var currentPage = 1
    var pageRequest = 1
    var totalPages = 2
    private (set) var search: Search
    private (set) var segmentControlItemsArray = ["Popular", "Upcoming", "Top Rated", "Now Playing"]
    private (set) var searchBarPlaceHolder = "Search for a movie or a Tv Show"
    
    private (set) var searchStatus: SearchStatus = .loading {
        didSet {
            delegate?.searchStatusDidUpdate(statusDidChangeTo: searchStatus)
        }
    }
    
    init(search: Search) {
        self.search = search
    }
    
    func fetch(category: Category) {
        guard currentPage < totalPages else { return }
        pageRequest = moviesArray.count == 0 ? currentPage : currentPage + 1
        searchStatus = .loading
        print(pageRequest)
        search.performSearch(category: category, page: pageRequest) {  results in
            switch results {
            case .success(let moviesResults):
                let newResults = moviesResults.results
                self.moviesArray.append(contentsOf: newResults)
                self.currentPage = moviesResults.page
                self.totalPages = moviesResults.totalPages
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
        
    func resetPagination() {
        moviesArray = []
        currentPage = 1
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
