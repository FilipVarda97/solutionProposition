import UIKit

protocol MatrixButtonDelegate: AnyObject {
    func press(odd: Odd)
    func longPress(odd: Odd)
}

class MatrixButton: UIView {

    // Constants
    let bgColor = UIColor.black
    let titleColor = UIColor.white
    let valueColor = UIColor.yellow

    // Views
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()

    let valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()

    // Properties
    weak var delegate: MatrixButtonDelegate? = nil
    var odd: Odd? {
        didSet {
            fillContent()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    private func setup() {
        self.backgroundColor = .black
        addActions()

        titleLabel.textColor = titleColor
        valueLabel.textColor = valueColor
        titleLabel.backgroundColor = .black
        valueLabel.backgroundColor = .black
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(20)
        }

        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(20)
        }
    }

    private func fillContent() {
        guard let title = odd?.nameOdds, let value = odd?.value else { return }
        titleLabel.text = title
        valueLabel.text = String(describing: value)
    }

    private func addActions() {
        let press = UITapGestureRecognizer(target: self, action: #selector(pressed))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
        addGestureRecognizer(press)
        addGestureRecognizer(longPress)
    }
    
    @objc private func pressed() {
        guard let delegate = delegate, let odd = odd else { return }
        delegate.press(odd: odd)
    }

    @objc private func longPressed() {
        guard let delegate = delegate, let odd = odd else { return }
        delegate.longPress(odd: odd)
    }
}
