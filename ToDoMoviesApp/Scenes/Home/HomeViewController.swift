import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = viewModel.searchBarPlaceHolder
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: viewModel.segmentControlItemsArray)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.addTarget(self, action: #selector(segmentControlDidChange), for: .valueChanged)
        return segmentControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ResultCell.self, forCellReuseIdentifier: String(describing: ResultCell.self))
        tableView.register(NoResultCell.self, forCellReuseIdentifier: String(describing: NoResultCell.self))
        tableView.register(LoadingCell.self, forCellReuseIdentifier: String(describing: LoadingCell.self))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        setupViews()
        setupContsraints()
        viewModel.resetPagination()
        viewModel.fetch(category: Category(rawValue: segmentControl.selectedSegmentIndex)!)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupViews() {
        view.addSubview(searchBar)
        view.addSubview(segmentControl)
        view.addSubview(tableView)
    }
    
    private func setupContsraints() {
        searchBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        segmentControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(segmentControl.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func createAlertErrorDialog(error: ApiError) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Ups...", message: error.errorDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "Try Again!", style: .default) {_ in
                self.viewModel.fetch(category: Category(rawValue: self.segmentControl.selectedSegmentIndex)!)
            }
            alertVC.addAction(action)
            self.present(alertVC, animated: true)
        }
    }
    
    @objc private func segmentControlDidChange(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        viewModel.resetPagination()
        viewModel.fetch(category: Category(rawValue: selectedSegmentIndex)!)
    }
}
extension HomeViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        2
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch viewModel.searchStatus {
            case .noResults, .loading, .error(_ ):
                return 1
            case .success:
                return viewModel.moviesArray.count
            }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            switch viewModel.searchStatus {
            case .loading, .error(_ ):
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingCell.self), for: indexPath) as! LoadingCell
                cell.spinActivityIndicator.startAnimating()
                return cell
            case .success:
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ResultCell.self), for: indexPath) as! ResultCell
                let movie = viewModel.moviesArray[indexPath.row]
                cell.configureUI(for: movie)
                return cell
            case .noResults:
                return tableView.dequeueReusableCell(withIdentifier: String(describing: NoResultCell.self), for: indexPath)
            }
        }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.moviesArray.count - 1 {
            viewModel.isLoadingMore = true
            viewModel.fetch(category: Category(rawValue: segmentControl.selectedSegmentIndex)!)
        }
    }
}
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController(viewModel: DetailViewModel(movie: viewModel.moviesArray[indexPath.row]))
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch viewModel.searchStatus {
        case .noResults, .loading, .error(_ ):
            return nil
        case .success:
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70
        default:
            return 30
        }
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func searchStatusDidUpdate(statusDidChangeTo status: SearchStatus) {
        switch status {
        case .noResults, .success, .loading:
            tableView.reloadData()
        case .error(let error):
            createAlertErrorDialog(error: error)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            viewModel.handleSearchText(searchText: searchText)
            tableView.reloadData()
        } else {
            searchBar.placeholder = "Search for a movie or a Tv Show"
            viewModel.fetch(category: Category(rawValue: segmentControl.selectedSegmentIndex)!)
        }
    }
}

