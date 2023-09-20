import UIKit

public final class DetailsHeaderView: UIView {
  let idLabel = UILabel()
  let timeLabel = UILabel()
  let titleLabel = UILabel()
  let stackView = UIStackView()

  init() {
    super.init(frame: .zero)

    idLabel.font = .systemFont(ofSize: 8)
    titleLabel.font = .boldSystemFont(ofSize: 21)
    timeLabel.font = .systemFont(ofSize: 12)

    idLabel.textAlignment = .center
    titleLabel.textAlignment = .center
    timeLabel.textAlignment = .center

    addSubview(stackView)
    translatesAutoresizingMaskIntoConstraints = false
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.addArrangedSubview(idLabel)
    stackView.addArrangedSubview(titleLabel)
    stackView.addArrangedSubview(timeLabel)

    stackView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
    stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
    stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
    stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true

    stackView.spacing = 4
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
  }

  required init?(coder: NSCoder) { nil }
}
