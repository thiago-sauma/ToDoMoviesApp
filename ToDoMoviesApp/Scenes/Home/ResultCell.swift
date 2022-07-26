

import UIKit
import SnapKit
import Kingfisher

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
            label.numberOfLines = 0
            label.font = UIFont.boldSystemFont(ofSize: 14)
            return label
        }()
        
        private lazy var resultReleaseLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.italicSystemFont(ofSize: 12)
            label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return label
        }()
                        
        private lazy var verticalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillProportionally
            return stackView
        }()
    

        private func setupView() {
            self.addSubview(resultImageView)
            self.addSubview(verticalStackView)
            
            verticalStackView.addArrangedSubview(resultNameLabel)
            verticalStackView.addArrangedSubview(resultReleaseLabel)
        }
        
        private func setupConstraints() {
            resultImageView.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.leading.equalToSuperview().offset(8)
                $0.width.height.equalTo(60)
            }
            
            verticalStackView.snp.makeConstraints {
                $0.leading.equalTo(resultImageView.snp.trailing).offset(8)
                $0.height.equalTo(resultImageView.snp.height)
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(8)
            }
        }
        
        func configureUI(for movie: Movie) {
            resultNameLabel.text = movie.title
            guard let date = dateFormatterFromString.date(from: movie.release) else { return }
            resultReleaseLabel.text = dateFormatterToString.string(from: date)
            configureImageView(for: movie)
        }
        
        private func configureImageView(for movie: Movie) {
            guard let urlString = movie.poster else {
                if let image = UIImage(systemName: "moon.fill") {
                    imageView?.image = image
                }
                return
            }
            guard let url = URL(string: "https://image.tmdb.org/t/p/original/" + urlString) else {
               return
            }
            resultImageView.kf.setImage(with: url)
        }

}
