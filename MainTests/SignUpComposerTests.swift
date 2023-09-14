import Main
import UI
import Validation
import XCTest

final class SignUpComposerTests: XCTestCase {
  func test_backgroundRequestShouldCompleteOnMainThread() {
    let (sut, addAccountSpy) = makeSUT()
    sut.loadViewIfNeeded()
    sut.signUp?(makeSignUpViewModel())
    let exp = expectation(description: "waiting")
    DispatchQueue.global().async {
      addAccountSpy.completeWithError(.unexpected)
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1)
  }

  func test_signUpComposerWithCorrectValidations() {
    let validations = SignUpComposer.makeValidations()
    XCTAssertEqual(
      validations[0] as! RequiredFieldValidation,
      RequiredFieldValidation(
        fieldName: "name",
        fieldLabel: "Nome"
      )
    )
    XCTAssertEqual(
      validations[1] as! RequiredFieldValidation,
      RequiredFieldValidation(
        fieldName: "email",
        fieldLabel: "Email"
      )
    )
    XCTAssertEqual(
      validations[2] as! EmailValidation,
      EmailValidation(
        fieldName: "email",
        fieldLabel: "Email",
        emailValidator: EmailValidatorSpy()
      )
    )
    XCTAssertEqual(
      validations[3] as! RequiredFieldValidation,
      RequiredFieldValidation(
        fieldName: "password",
        fieldLabel: "Senha"
      )
    )
    XCTAssertEqual(
      validations[4] as! RequiredFieldValidation,
      RequiredFieldValidation(
        fieldName: "passwordConfirmation",
        fieldLabel: "Confirmar Senha"
      )
    )
    XCTAssertEqual(
      validations[5] as! CompareFieldsValidation,
      CompareFieldsValidation(
        fieldName: "password",
        fieldLabel: "Confirmar Senha",
        fieldNameToCompare: "passwordConfirmation"
      )
    )
  }
}

extension SignUpComposerTests {
  func makeSUT() -> (
    sut: SignUpViewController,
    addAccountSpy: AddAccountSpy
  ) {
    let addAccountSpy = AddAccountSpy()
    let sut = SignUpComposer.composeControllerWith(
      addAccount: MainQueueDispatchDecorator(addAccountSpy)
    )
    checkMemoryLeak(for: sut)
    checkMemoryLeak(for: addAccountSpy)
    return (sut, addAccountSpy)
  }
}
