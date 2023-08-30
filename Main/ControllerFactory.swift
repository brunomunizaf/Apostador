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

  static func makeSportsList(getSports: GetSports) -> SportsListViewController {
    let controller = SportsListViewController.instantiate()

    let presenter = SportsListPresenter(
      alertView: controller,
      getSports: getSports,
      loadingView: controller
    )
    controller.fetch = presenter.fetch
    return controller
  }
}
