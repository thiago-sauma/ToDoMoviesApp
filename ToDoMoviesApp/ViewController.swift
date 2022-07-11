
import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    var results = ["one", "two"]
    
    lazy var searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search for a movie or a Tv Show"
        return searchBar
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Movies", "Tv Shows"])
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MovieResultCell", bundle: nil), forCellReuseIdentifier: "MovieResultCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
         
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        setupViews()
        setupContsraints()
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
        results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let result = results[indexPath.row]
        cell.textLabel?.text = result
        return cell
    }
    
    
}

//protocol UnknownCase: RawRepresentable, CaseIterable where RawValue: Equatable & Codable {
//    static var unknownCase: Self { get }
//}
//
//extension UnknownCase {
//    init(rawValue: RawValue) {
//        let value = Self.allCases.first { $0.rawValue == rawValue }
//        self = value ?? Self.unknownCase
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let rawValue = try container.decode(RawValue.self)
//        let value = Self(rawValue: rawValue)
//        self = value ?? Self.unknownCase
//    }
//}
