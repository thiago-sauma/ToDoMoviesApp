enum SearchStatus {
    case noResults
    case success
    case loading
    case error(ApiError)
}
