

import UIKit
import SnapKit

    class ResultCell: UITableViewCell {
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            commonInit()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            commonInit()
        }
        
        private func commonInit() {
            setupView()
            setupConstraints()
        }
        
        private lazy var resultImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.image = UIImage(named: "moon.fill")
            return imageView
        }()
        
        private lazy var resultNameLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 17)
            return label
        }()
        
        private lazy var resultReleaseLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return label
        }()
        
        private lazy var resultGenresLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.setContentHuggingPriority(.defaultLow, for: .horizontal)
            return label
        }()
        
        private lazy var horizontalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .leading
            stackView.distribution = .fill
            stackView.spacing = 8
            return stackView
        }()
        
        private lazy var verticalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            return stackView
        }()
    

        private func setupView() {
            self.addSubview(resultImageView)
            self.addSubview(verticalStackView)
            
            verticalStackView.addArrangedSubview(resultNameLabel)
            verticalStackView.addArrangedSubview(horizontalStackView)
            
            horizontalStackView.addArrangedSubview(resultReleaseLabel)
            horizontalStackView.addArrangedSubview(resultGenresLabel)
            
        }
        
        private func setupConstraints() {
            resultImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(8)
                $0.width.height.equalTo(60)
            }
            
            verticalStackView.snp.makeConstraints {
                $0.leading.equalTo(resultImageView.snp.trailing).offset(16)
                $0.height.equalTo(resultImageView.snp.height)
                $0.centerY.equalToSuperview()
                $0.trailing.greaterThanOrEqualToSuperview().offset(8)
            }
        }
        
        func configureUI() {
            if let image = UIImage(systemName: "moon.fill") {
                imageView?.image = image
            }
            resultNameLabel.text = "Poderoso Chefao"
            resultReleaseLabel.text = "1992"
            resultGenresLabel.text = "Drama, ficcao"
        }

}
