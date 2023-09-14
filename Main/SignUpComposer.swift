import Domain
import Foundation
import Infra
import Presentation
import UI
import Validation

public final class SignUpComposer {
  public static func composeControllerWith(addAccount: AddAccount) -> SignUpViewController {
    let controller = SignUpViewController.instantiate()
    let validationComposite = ValidationComposite(
      validations: makeValidations()
    )
    let presenter = SignUpPresenter(
      alertView: WeakVarProxy(controller),
      loadingView: WeakVarProxy(controller),
      addAccount: addAccount,
      validation: validationComposite
    )
    controller.signUp = presenter.signUp
    return controller
  }

  public static func makeValidations() -> [Validation] {
    [
      RequiredFieldValidation(
        fieldName: "name",
        fieldLabel: "Nome"
      ),
      RequiredFieldValidation(
        fieldName: "email",
        fieldLabel: "Email"
      ),
      EmailValidation(
        fieldName: "email",
        fieldLabel: "Email",
        emailValidator: EmailValidatorAdapter()
      ),
      RequiredFieldValidation(
        fieldName: "password",
        fieldLabel: "Senha"
      ),
      RequiredFieldValidation(
        fieldName: "passwordConfirmation",
        fieldLabel: "Confirmar Senha"
      ),
      CompareFieldsValidation(
        fieldName: "password",
        fieldLabel: "Confirmar Senha",
        fieldNameToCompare: "passwordConfirmation"
      )
    ]
  }
}
