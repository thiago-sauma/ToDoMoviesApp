import UIKit
import SnapKit
import Kingfisher

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var resultImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var resultNameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var resultRatingLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var resultGenresLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var resultDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
        stackView.spacing = 16
        stackView.alignment = .leading
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var returnButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        setupView()
        setupConstraints()
        updateUI()
    }
    
    private func setupView() {
        view.addSubview(resultImageView)
        view.addSubview(returnButton)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(resultNameLabel)
        stackView.addArrangedSubview(resultRatingLabel)
        stackView.addArrangedSubview(resultGenresLabel)
        stackView.addArrangedSubview(resultDescriptionLabel)
    }
    
    private func setupConstraints() {
        resultImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(view.frame.width / 1.5)
            $0.height.equalTo(view.frame.height / 2.0)
            $0.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(resultImageView.snp.bottom).offset(8)
        }
        
        returnButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(8)
        }
    }
    
    private func updateUI() {
        resultNameLabel.text = viewModel.movie.title
        resultGenresLabel.text = viewModel.movie.getGenresArray(genreIds: viewModel.movie.genres)
        resultRatingLabel.text = "Vote Average: " + String(viewModel.movie.grade)
        resultDescriptionLabel.text = viewModel.movie.overview
        configureImageView(for: viewModel.movie)
                
    }
    
    private func configureImageView(for movie: Movie) {
        guard let urlString = movie.poster else {
            if let image = UIImage(systemName: "moon.fill") {
                resultImageView.image = image
            }
            return
        }
        guard let url = URL(string: "https://image.tmdb.org/t/p/original/" + urlString) else {
           return
        }
        resultImageView.kf.setImage(with: url)
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
}
