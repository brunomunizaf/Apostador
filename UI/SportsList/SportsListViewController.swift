import Domain
import Presentation
import UIKit

public final class SportsListViewController: UIViewController, Storyboarded {
  @IBOutlet weak var sportsTableView: UITableView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  public var dataSet = [Sport]()
  public var push: ((Sport) -> Void)?
  public var fetch: ((@escaping ([Sport]) -> Void) -> Void)?

  public override func viewDidLoad() {
    super.viewDidLoad()
    sportsTableView.delegate = self
    sportsTableView.dataSource = self
    fetch? { [weak self] sports in
      guard let self else { return }
      self.dataSet = sports.sorted(by: { $0.title < $1.title })
      self.sportsTableView.reloadData()
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
      withIdentifier: "SportsListCell",
      for: indexPath
    )
    cell.textLabel?.text = dataSet[indexPath.row].title
    return cell
  }
}

extension SportsListViewController: UITableViewDelegate {
  public func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    push?(dataSet[indexPath.row])
  }
}
