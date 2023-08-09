import Domain
import Presentation
import XCTest

final class SignUpPresenterTests: XCTestCase {
  func test_signUpShouldShowErrorMessageIfNameIsNotProvided() {
    let alertViewSpy = AlertViewSpy()
    let sut = makeSUT(alertView: alertViewSpy)
    let exp = expectation(description: "waiting")
    alertViewSpy.observe {
      XCTAssertEqual($0, makeRequiredAlertViewModel(fieldName: "nome"))
      exp.fulfill()
    }

    sut.signUp(viewModel: makeSignUpViewModel(name: nil))
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldShowErrorMessageIfEmailIsNotProvided() {
    let alertViewSpy = AlertViewSpy()
    let sut = makeSUT(alertView: alertViewSpy)
    let exp = expectation(description: "waiting")
    alertViewSpy.observe {
      XCTAssertEqual($0, makeRequiredAlertViewModel(fieldName: "email"))
      exp.fulfill()
    }

    sut.signUp(viewModel: makeSignUpViewModel(email: nil))
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldShowErrorMessageIfPasswordIsNotProvided() {
    let alertViewSpy = AlertViewSpy()
    let sut = makeSUT(alertView: alertViewSpy)
    let exp = expectation(description: "waiting")
    alertViewSpy.observe {
      XCTAssertEqual($0, makeRequiredAlertViewModel(fieldName: "senha"))
      exp.fulfill()
    }

    sut.signUp(viewModel: makeSignUpViewModel(password: nil))
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldShowErrorMessageIfPasswordConfirmationIsNotProvided() {
    let alertViewSpy = AlertViewSpy()
    let sut = makeSUT(alertView: alertViewSpy)
    let exp = expectation(description: "waiting")
    alertViewSpy.observe {
      XCTAssertEqual($0, makeRequiredAlertViewModel(fieldName: "confirmação de senha"))
      exp.fulfill()
    }

    sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldShowErrorMessageIfPasswordConfirmationDoesntMatch() {
    let alertViewSpy = AlertViewSpy()
    let sut = makeSUT(alertView: alertViewSpy)
    let exp = expectation(description: "waiting")
    alertViewSpy.observe {
      XCTAssertEqual($0, makeInvalidAlertViewModel(fieldName: "confirmação de senha"))
      exp.fulfill()
    }

    sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: "any_other_password"))
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldCallEmailValidatorWithCorrectEmail() {
    let emailValidatorSpy = EmailValidatorSpy()
    let sut = makeSUT(emailValidator: emailValidatorSpy)
    let viewModel = makeSignUpViewModel()

    sut.signUp(viewModel: viewModel)

    XCTAssertEqual(
      emailValidatorSpy.email,
      viewModel.email
    )
  }

  func test_signUpShouldShowErrorMessageIfInvalidEmailIsProvided() {
    let alertViewSpy = AlertViewSpy()
    let viewModel = makeSignUpViewModel()
    let emailValidatorSpy = EmailValidatorSpy()
    let exp = expectation(description: "waiting")
    alertViewSpy.observe {
      XCTAssertEqual($0, makeInvalidAlertViewModel(fieldName: "email"))
      exp.fulfill()
    }
    let sut = makeSUT(
      alertView: alertViewSpy,
      emailValidator: emailValidatorSpy
    )
    emailValidatorSpy.simulateInvalidEmail()
    sut.signUp(viewModel: viewModel)
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldCallAddAccountWithCorrectValues() {
    let addAccountSpy = AddAccountSpy()
    let sut = makeSUT(addAccount: addAccountSpy)
    sut.signUp(viewModel: makeSignUpViewModel())

    XCTAssertEqual(
      addAccountSpy.viewModel,
      makeAddAccountModel()
    )
  }

  func test_signUpShouldShowErrorMessageIfAddAccountFails() {
    let alertViewSpy = AlertViewSpy()
    let addAccountSpy = AddAccountSpy()
    let sut = makeSUT(
      alertView: alertViewSpy,
      addAccount: addAccountSpy
    )
    let exp = expectation(description: "waiting")
    alertViewSpy.observe {
      XCTAssertEqual(
        $0, makeErrorAlertViewModel(message: "Algo inesperado aconteceu, tente novamente em instantes")
      )
      exp.fulfill()
    }
    sut.signUp(viewModel: makeSignUpViewModel())
    addAccountSpy.completeWithError(.unexpected)
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldShowLoadingBeforeAndAfterCallAddAccount() {
    let addAccountSpy = AddAccountSpy()
    let loadingViewSpy = LoadingViewSpy()
    let sut = makeSUT(
      loadingView: loadingViewSpy,
      addAccount: addAccountSpy
    )
    let exp = expectation(description: "waiting")
    loadingViewSpy.observe { viewModel in
      XCTAssertEqual(
        viewModel,
        LoadingViewModel(isLoading: true)
      )
      exp.fulfill()
    }
    sut.signUp(viewModel: makeSignUpViewModel())
    wait(for: [exp], timeout: 1)
    let exp2 = expectation(description: "waiting")
    loadingViewSpy.observe { viewModel in
      XCTAssertEqual(
        viewModel,
        LoadingViewModel(isLoading: false)
      )
      exp2.fulfill()
    }
    addAccountSpy.completeWithError(.unexpected)
    wait(for: [exp2], timeout: 1)
  }

  func test_signUpShouldShowSuccessMessageIfAddAccountSucceeds() {
    let alertViewSpy = AlertViewSpy()
    let addAccountSpy = AddAccountSpy()
    let sut = makeSUT(
      alertView: alertViewSpy,
      addAccount: addAccountSpy
    )
    let exp = expectation(description: "waiting")
    alertViewSpy.observe {
      XCTAssertEqual($0, makeSuccessAlertViewModel(message: "Conta criada com sucesso."))
      exp.fulfill()
    }
    sut.signUp(viewModel: makeSignUpViewModel())
    addAccountSpy.completeWithAccount(makeAccountModel())
    wait(for: [exp], timeout: 1)
  }
}

extension SignUpPresenterTests {
  func makeSUT(
    alertView: AlertViewSpy = .init(),
    emailValidator: EmailValidatorSpy = .init(),
    loadingView: LoadingViewSpy = .init(),
    addAccount: AddAccountSpy = .init()
  ) -> SignUpPresenter {
    let sut = SignUpPresenter(
      alertView: alertView,
      emailValidator: emailValidator,
      loadingView: loadingView,
      addAccount: addAccount
    )
    addTeardownBlock { [weak sut] in
      XCTAssertNil(sut)
    }
    return sut
  }
}
