

import UIKit
import SnapKit

class DetailViewController: UIViewController {
    
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
        return label
    }()
    
    private lazy var resultDescriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillProportionally
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
            $0.width.equalTo(view.frame.width / 2.0)
            $0.height.equalTo(view.frame.height / 2.0)
            $0.centerX.equalToSuperview()
        }
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(resultImageView.snp.bottom).offset(8)
        }
        
        returnButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalToSuperview().offset(8)
        }
    }
    
    private func updateUI() {
        if let image = UIImage(systemName: "moon.fill") {
            resultImageView.image = image
        }
        resultNameLabel.text = "Poderoso chefao"
        resultGenresLabel.text = "Drama, ficcao"
        resultRatingLabel.text = "9,98"
        resultDescriptionLabel.text = "Um belissimo filme"
        
    }
    
    @objc private func close() {
        navigationController?.popViewController(animated: true)
    }
}
