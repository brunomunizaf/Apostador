import Domain
import Presentation
import UIKit

public final class SportsListViewController: UIViewController, Storyboarded {
  @IBOutlet weak var sportsTableView: UITableView!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  public var push: ((Sport) -> Void)?
  public var dataSet = [SportsListViewModel]() {
    didSet {
      if !dataSet.isEmpty {
        contentUnavailableConfiguration = .none
      }
    }
  }
  public var fetch: ((@escaping ([SportsListViewModel]) -> Void) -> Void)?

  public override func viewDidLoad() {
    super.viewDidLoad()
    title = "Esportes"

    setupTableEmptyState()
    sportsTableView.delegate = self
    sportsTableView.dataSource = self
    fetch? { [weak self] sports in
      guard let self else { return }
      dataSet = sports
      sportsTableView.reloadData()
    }
  }

  private func setupTableEmptyState() {
    var configuration = UIContentUnavailableConfiguration.empty()
    configuration.image = UIImage(systemName: "questionmark.circle")
    configuration.text = "Cadê os esportes?"
    configuration.textProperties.color = .white
    configuration.secondaryText = "Bem, normalmente os esportes estariam aqui..."
    contentUnavailableConfiguration = configuration
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
    var content = cell.defaultContentConfiguration()
    content.text = dataSet[indexPath.section].sports[indexPath.row].title
    content.secondaryText = dataSet[indexPath.section].sports[indexPath.row].description
    cell.contentConfiguration = content
    cell.selectionStyle = .none
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
