import Domain
import Foundation
import Presentation
import UI
import Validation

public final class SignUpComposer {
  public static func composeControllerWith(addAccount: AddAccount) -> SignUpViewController {
    let controller = SignUpViewController.instantiate()
    let emailValidatorAdapter = EmailValidatorAdapter()
    let presenter = SignUpPresenter(
      alertView: WeakVarProxy(controller),
      emailValidator: emailValidatorAdapter,
      loadingView: WeakVarProxy(controller),
      addAccount: addAccount
    )
    controller.signUp = presenter.signUp
    return controller
  }
}
