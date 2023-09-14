import Domain
import Presentation
import UIKit

public final class SportsListViewController: UIViewController, Storyboarded {
  @IBOutlet weak var sportsTableView: UITableView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  public var fetch: (() -> Void)?
  public var dataSet = [String: [SportModel]]()

  public override func viewDidLoad() {
    super.viewDidLoad()
    sportsTableView.dataSource = self
    fetch?()
  }
}

extension SportsListViewController: DisplaySports {
  public func display(_ models: [SportModel]) {
    dataSet = Dictionary(grouping: models, by: \.group)
    sportsTableView.reloadData()
  }
}

extension SportsListViewController: LoadingView {
  public func display(viewModel: LoadingViewModel) {
    if viewModel.isLoading {
      view.isUserInteractionEnabled = false
      loadingIndicator?.startAnimating()
    } else {
      view.isUserInteractionEnabled = true
      loadingIndicator?.stopAnimating()
    }
  }
}

extension SportsListViewController: AlertView {
  public func showMessage(viewModel: AlertViewModel) {
    let alert = UIAlertController(
      title: viewModel.title,
      message: viewModel.message,
      preferredStyle: .alert
    )
    alert.addAction(UIAlertAction(
      title: "OK",
      style: .default
    ))
    present(alert, animated: true)
  }
}

extension SportsListViewController: UITableViewDataSource {
  public func numberOfSections(in tableView: UITableView) -> Int {
    dataSet.keys.count
  }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let value = dataSet[Array(dataSet.keys)[section]] else { return 0 }
    return value.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SportsListCell", for: indexPath)
    let key = Array(dataSet.keys)[indexPath.section]
    if let value = dataSet[key] {
      cell.textLabel?.text = value[indexPath.row].title
    }
    return cell
  }
}
