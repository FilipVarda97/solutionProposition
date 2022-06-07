import UIKit
import SnapKit

enum CornerStyle {
    case top
    case bottom
}

protocol MatrixCellDelegate: AnyObject {
    func press(odd: Odd)
    func longPress(odd: Odd)
}

class MatrixRowCell: UITableViewCell {

    // Constants
    static let identifier = "MatrixRowCell"
    let buttonHeight = 40.0
    let titleHeight = 30.0
    let separatorWidth = 1.0
    let titleBackground = UIColor.darkGray
    let insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)

    // Views
    let titleLabel: InsetLabel = InsetLabel()
    var buttons = [MatrixButton]()
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    let firstRowStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 1
        return stackView
    }()
    let secondRowStackView: UIStackView = {
        let stackView = UIStackView()
         stackView.alignment = .center
         stackView.distribution = .fillEqually
         stackView.axis = .horizontal
         stackView.spacing = 1
         return stackView
    }()
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    // Properties
    weak var delegate: MatrixCellDelegate? = nil
    var element: [Player: [Odd]]? {
        didSet {
            populateCell()
        }
    }
    var isFirst: Bool = false
    var isLast: Bool = false

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    private func populateCell() {
        guard let element = element,
              let player = element.first?.key,
              let odds = element[player]
        else { return }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(insets)
        }

        titleLabel.text = player.nameOdds
        titleLabel.textColor = .white
        titleLabel.backgroundColor = .gray
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(titleHeight)
        }

        createButtons(odds: odds)
    }

    private func createButtons(odds: [Odd]) {
        buttons.removeAll()
        for odd in odds {
            let button = MatrixButton()
            button.odd = odd
            button.delegate = self
            buttons.append(button)
        }

        firstRowStackView.removeAllArrangedSubviews()
        secondRowStackView.removeAllArrangedSubviews()

        containerView.addSubview(firstRowStackView)

        firstRowStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(buttonHeight)
        }

        containerView.addSubview(separatorView)
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
            make.top.equalTo(firstRowStackView.snp.bottom)
        }
        
        containerView.addSubview(secondRowStackView)

        secondRowStackView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(separatorView.snp.bottom)
        }

        for button in buttons {
            if button.odd!.displayOrder <= 3 {
                firstRowStackView.addArrangedSubview(button)
            } else {
                secondRowStackView.addArrangedSubview(button)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isFirst {
            containerView.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        }
        if isLast {
            containerView.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
        }
    }
}

extension MatrixRowCell: MatrixButtonDelegate {
    func press(odd: Odd) {
        guard let delegate = delegate else { return }
        delegate.press(odd: odd)
    }
    
    func longPress(odd: Odd) {
        guard let delegate = delegate else { return }
        delegate.longPress(odd: odd)
    }
}
