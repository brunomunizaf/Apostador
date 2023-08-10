import Presentation
import UIKit

final class SignUpViewController: UIViewController {
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  var signUp: ((SignUpViewModel) -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()

    signUpButton.addTarget(
      self,
      action: #selector(didTapSignUp),
      for: .touchUpInside
    )
  }

  @objc func didTapSignUp() {
    signUp?(.init(
      name: nil,
      email: nil,
      password: nil,
      passwordConfirmation: nil
    ))
  }
}

extension SignUpViewController: LoadingView {
  func display(viewModel: LoadingViewModel) {
    if viewModel.isLoading {
      loadingIndicator?.startAnimating()
    } else {
      loadingIndicator?.stopAnimating()
    }
  }
}

extension SignUpViewController: AlertView {
  func showMessage(viewModel: AlertViewModel) {
    
  }
}
