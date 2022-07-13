
import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Popular", "Upcoming", "Top Rated", "Now Playing"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.addTarget(self, action: #selector(segmentControlDidChange), for: .valueChanged)
        return segmentControl
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        tableView.register(ResultCell.self, forCellReuseIdentifier: String(describing: ResultCell.self))
        tableView.register(NoResultCell.self, forCellReuseIdentifier: String(describing: NoResultCell.self))
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
        viewModel.fetch(category: Category(rawValue: segmentControl.selectedSegmentIndex)!)
    }
    
    private func configureUI() {
        searchBar.placeholder = "Search for a movie or a Tv Show"
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
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.moviesArray.count {
        case 0: return 1
        default: return viewModel.moviesArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if viewModel.moviesArray.isEmpty {
            return tableView.dequeueReusableCell(withIdentifier: String(describing: NoResultCell.self), for: indexPath) as! NoResultCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ResultCell.self), for: indexPath) as! ResultCell
            let movie = viewModel.moviesArray[indexPath.row]
            cell.configureUI(for: movie)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController(viewModel: DetailViewModel(movie: viewModel.moviesArray[indexPath.row]))
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if viewModel.moviesArray.isEmpty && indexPath.row == 0 {
            return nil
        }
        return indexPath
    }
    
}

extension HomeViewController {
    @objc func segmentControlDidChange(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        viewModel.fetch(category: Category(rawValue: selectedSegmentIndex)!)
    }
}

extension HomeViewController: HomeViewModelDelegate {
    func updateErrorMessage(with error: ApiError) {
        createAlertErrorDialog(error: error)
    }
    
    func updateMovieResultsArray(with results: [Movie]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
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

