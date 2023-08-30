import Presentation
import UIKit

public final class SportsListViewController: UIViewController, Storyboarded {
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  public var fetch: (() -> Void)?

  public override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    fetch?()
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
