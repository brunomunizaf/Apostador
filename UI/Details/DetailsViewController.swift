import Domain
import UIKit

public final class DetailsViewController: UIViewController, Storyboarded {
  @IBOutlet weak var detailsTableView: UITableView!

  public var model: Odd!

  private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "pt_BR")
    formatter.setLocalizedDateFormatFromTemplate("EEEE dd MMMM 'às' HH:mm")
    return formatter
  }()

  private let relativeDateFormatter: RelativeDateTimeFormatter = {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    formatter.dateTimeStyle = .numeric
    formatter.locale = Locale(identifier: "pt_BR")
    return formatter
  }()

  public override func viewDidLoad() {
    super.viewDidLoad()
    title = "Detalhes da partida"

    detailsTableView.dataSource = self
    setupHeaderView()
  }

  private func setupHeaderView() {
    let headerView = DetailsHeaderView()
    headerView.idLabel.text = model.id
    headerView.titleLabel.text = {
      var content = ""
      if !model.homeTeam.isEmpty {
        content += model.homeTeam
      }
      if !model.awayTeam.isEmpty {
        content += " x \(model.awayTeam)"
      }
      return content
    }()

    headerView.timeLabel.text = dateFormatter.string(from: model.commenceTime)
    headerView.translatesAutoresizingMaskIntoConstraints = false
    detailsTableView.tableHeaderView = headerView

    headerView.widthAnchor.constraint(
      equalTo: detailsTableView.widthAnchor
    ).isActive = true

    detailsTableView.layoutIfNeeded()
  }
}

extension DetailsViewController: UITableViewDataSource {
  public func tableView(
    _ tableView: UITableView,
    titleForHeaderInSection section: Int
  ) -> String? {
    model.bookmakers[section].title
  }

  public func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    model.bookmakers[section].markets.count
  }

  public func numberOfSections(in tableView: UITableView) -> Int {
    model.bookmakers.count
  }

  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let lastUpdate = relativeDateFormatter.localizedString(
      for: model.bookmakers[indexPath.section].markets[indexPath.row].lastUpdate,
      relativeTo: Date()
    )
    let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell", for: indexPath)
    var content = cell.defaultContentConfiguration()
    let stringArrays = model
      .bookmakers[indexPath.section]
      .markets[indexPath.row]
      .outcomes
      .map { outcome in
        let name = outcome.name
        let price = String(outcome.price)
        let point = outcome.point.map { String($0) } ?? ""
        let description = outcome.description ?? ""

        return [name, price, point, description]
    }
    let concatenatedString = stringArrays.flatMap { $0 }.joined(separator: " ")
    content.text = concatenatedString

    let marketKey = model.bookmakers[indexPath.section].markets[indexPath.row].key
    content.secondaryText = "\(marketKey.uppercased()) | Última atualização \(lastUpdate)"
    cell.contentConfiguration = content
    cell.selectionStyle = .none
    return cell
  }
}
