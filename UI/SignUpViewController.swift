import Presentation
import UIKit

public final class SignUpViewController: UIViewController, Storyboarded {
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var confirmPasswordTextField: UITextField!
  @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

  var signUp: ((SignUpViewModel) -> Void)?

  public override func viewDidLoad() {
    super.viewDidLoad()

    signUpButton.addTarget(
      self,
      action: #selector(didTapSignUp),
      for: .touchUpInside
    )
    hideKeyboardOnTap()
  }

  @objc private func didTapSignUp() {
    let viewModel = SignUpViewModel(
      name: nameTextField.text,
      email: emailTextField.text,
      password: passwordTextField.text,
      passwordConfirmation: confirmPasswordTextField.text
    )
    signUp?(viewModel)
  }
}

extension SignUpViewController: LoadingView {
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

extension SignUpViewController: AlertView {
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
