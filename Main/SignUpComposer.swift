import Domain
import Foundation
import UI

public final class SignUpComposer {
  static func composeControllerWith(addAccount: AddAccount) -> SignUpViewController {
    ControllerFactory.makeSignUp(addAccount: addAccount)
  }
}
