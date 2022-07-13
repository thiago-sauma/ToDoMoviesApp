

import UIKit
import SnapKit

class NoResultCell: UITableViewCell {
    
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        configureView()
        makeConstraints()
    }
    
    private lazy var noResultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "No Result Found. Try Again!"
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func configureView() {
        self.addSubview(noResultLabel)
    }
    
    private func makeConstraints() {
        noResultLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    

}
