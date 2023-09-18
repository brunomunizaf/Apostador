import Domain
import Presentation
import UIKit

public final class OddsListViewController: UIViewController, Storyboarded {
  @IBOutlet weak var oddsTableView: UITableView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  public var dataSet = [Odd]()
  public var fetch: ((@escaping ([Odd]) -> Void) -> Void)?

  public override func viewDidLoad() {
    super.viewDidLoad()
    oddsTableView.delegate = self
    oddsTableView.dataSource = self
    fetch? { [weak self] odds in
      guard let self else { return }
      self.dataSet = odds
      self.oddsTableView.reloadData()
    }
  }
}

extension OddsListViewController: LoadingView {
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

extension OddsListViewController: AlertView {
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

extension OddsListViewController: UITableViewDataSource {
  public func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    dataSet.count
  }

  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "OddsListCell",
      for: indexPath
    )
    let string = "\(dataSet[indexPath.row].homeTeam) x \(dataSet[indexPath.row].awayTeam)"
    cell.textLabel?.text = string
    cell.textLabel?.numberOfLines = 0
    return cell
  }
}

extension OddsListViewController: UITableViewDelegate {
  public func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    // TODO: ...
  }
}
