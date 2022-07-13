
import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    var moviesArray = [Movie]()
    var search: Search!
    
    lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        //searchBar.delegate = self
        searchBar.placeholder = "Search for a movie or a Tv Show"
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
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        search = Search()
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        setupViews()
        setupContsraints()
        search.performSearch(category: .popular) { results in
            DispatchQueue.main.async {
                self.moviesArray = results
                self.tableView.reloadData()
            }
        }
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
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if moviesArray.isEmpty {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ResultCell.self), for: indexPath) as! ResultCell
        let movie = moviesArray[indexPath.row]
        cell.configureUI(for: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.movie = moviesArray[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

extension HomeViewController {
    @objc func segmentControlDidChange(_ sender: UISegmentedControl) {
        let selectedSegmentIndex = sender.selectedSegmentIndex
        search.performSearch(category: Category(rawValue: selectedSegmentIndex)!) { results in
            DispatchQueue.main.async {
                self.moviesArray = results
                self.tableView.reloadData()
            }
        }
    }
}

//extension HomeViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        search.performSearch(url: searchBar.text!)
//    }
//}

