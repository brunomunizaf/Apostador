import Data
import Domain
import Foundation
import Infra
import Presentation
import UI
import Validation

final class ControllerFactory {
  static func makeSignUp(addAccount: AddAccount) -> SignUpViewController {
    let controller = SignUpViewController.instantiate()
    let emailValidatorAdapter = EmailValidatorAdapter()

    let presenter = SignUpPresenter(
      alertView: controller,
      emailValidator: emailValidatorAdapter,
      loadingView: controller,
      addAccount: addAccount
    )
    controller.signUp = presenter.signUp
    return controller
  }
}
