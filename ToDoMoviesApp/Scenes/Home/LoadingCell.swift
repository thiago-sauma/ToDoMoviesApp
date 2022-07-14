

import UIKit
import SnapKit

class LoadingCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupViews()
        makeConstraints()
    }
    
     lazy var spinActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    private lazy var loadingLabel: UILabel = {
       let label = UILabel()
        label.text = "Loading Results..."
        return label
    }()
    
    private lazy var horizontalStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.spacing = 8
        return stackView
    }()

    private func setupViews() {
        addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(spinActivityIndicator)
        horizontalStackView.addArrangedSubview(loadingLabel)
    }
    
    private func makeConstraints() {
        horizontalStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }



}
