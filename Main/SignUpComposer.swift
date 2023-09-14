import Domain
import Foundation
import Presentation
import UI
import Validation

public final class SignUpComposer {
  public static func composeControllerWith(addAccount: AddAccount) -> SignUpViewController {
    let controller = SignUpViewController.instantiate()
    let presenter = SignUpPresenter(
      alertView: WeakVarProxy(controller),
      loadingView: WeakVarProxy(controller),
      addAccount: addAccount,
      validation: nil
    )
    controller.signUp = presenter.signUp
    return controller
  }
}
