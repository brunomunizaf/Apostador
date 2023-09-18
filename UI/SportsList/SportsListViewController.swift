import Domain
import Presentation
import UIKit

public final class SportsListViewController: UIViewController, Storyboarded {
  @IBOutlet weak var sportsTableView: UITableView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  public var push: ((Sport) -> Void)?
  public var dataSet = [SportsListViewModel]()
  public var fetch: ((@escaping ([SportsListViewModel]) -> Void) -> Void)?

  public override func viewDidLoad() {
    super.viewDidLoad()
    sportsTableView.delegate = self
    sportsTableView.dataSource = self
    fetch? { [weak self] sports in
      guard let self else { return }
      dataSet = sports
      sportsTableView.reloadData()
    }
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
    dataSet.count
  }

  public func tableView(
    _ tableView: UITableView,
    titleForHeaderInSection section: Int
  ) -> String? {
    dataSet[section].title
  }

  public func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    dataSet[section].sports.count
  }

  public func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "SportsListCell",
      for: indexPath
    )
    let title = dataSet[indexPath.section].sports[indexPath.row].title
    cell.textLabel?.text = title
    return cell
  }
}

extension SportsListViewController: UITableViewDelegate {
  public func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    push?(dataSet[indexPath.section].sports[indexPath.row])
  }
}
