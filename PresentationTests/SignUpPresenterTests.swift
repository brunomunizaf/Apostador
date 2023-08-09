import Domain
import Presentation
import XCTest

final class SignUpPresenterTests: XCTestCase {
  func test_signUpShouldShowErrorMessageIfNameIsNotProvided() {
    let alertViewSpy = AlertViewSpy()
    let sut = makeSUT(alertView: alertViewSpy)
    let exp = expectation(description: "waiting")
    alertViewSpy.observe { [weak self] viewModel in
      XCTAssertEqual(
        viewModel,
        self?.makeRequiredAlertViewModel(fieldName: "nome")
      )
      exp.fulfill()
    }

    sut.signUp(viewModel: makeSignUpViewModel(name: nil))
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldShowErrorMessageIfEmailIsNotProvided() {
    let alertViewSpy = AlertViewSpy()
    let sut = makeSUT(alertView: alertViewSpy)
    let exp = expectation(description: "waiting")
    alertViewSpy.observe { [weak self] viewModel in
      XCTAssertEqual(
        viewModel,
        self?.makeRequiredAlertViewModel(fieldName: "email")
      )
      exp.fulfill()
    }

    sut.signUp(viewModel: makeSignUpViewModel(email: nil))
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldShowErrorMessageIfPasswordIsNotProvided() {
    let alertViewSpy = AlertViewSpy()
    let sut = makeSUT(alertView: alertViewSpy)
    let exp = expectation(description: "waiting")
    alertViewSpy.observe { [weak self] viewModel in
      XCTAssertEqual(
        viewModel,
        self?.makeRequiredAlertViewModel(fieldName: "senha")
      )
      exp.fulfill()
    }

    sut.signUp(viewModel: makeSignUpViewModel(password: nil))
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldShowErrorMessageIfPasswordConfirmationIsNotProvided() {
    let alertViewSpy = AlertViewSpy()
    let sut = makeSUT(alertView: alertViewSpy)
    let exp = expectation(description: "waiting")
    alertViewSpy.observe { [weak self] viewModel in
      XCTAssertEqual(
        viewModel,
        self?.makeRequiredAlertViewModel(fieldName: "confirmação de senha")
      )
      exp.fulfill()
    }

    sut.signUp(viewModel: makeSignUpViewModel(passwordConfirmation: nil))
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldShowErrorMessageIfPasswordConfirmationDoesntMatch() {
    let alertViewSpy = AlertViewSpy()
    let sut = makeSUT(alertView: alertViewSpy)
    let exp = expectation(description: "waiting")
    alertViewSpy.observe { [weak self] viewModel in
      XCTAssertEqual(
        viewModel,
        self?.makeInvalidAlertViewModel(fieldName: "confirmação de senha")
      )
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
    alertViewSpy.observe { [weak self] viewModel in
      XCTAssertEqual(
        viewModel,
        self?.makeInvalidAlertViewModel(fieldName: "email")
      )
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
    alertViewSpy.observe { [weak self] viewModel in
      XCTAssertEqual(
        viewModel,
        self?.makeErrorAlertViewModel(message: "Algo inesperado aconteceu, tente novamente em instantes")
      )
      exp.fulfill()
    }
    sut.signUp(viewModel: makeSignUpViewModel())
    addAccountSpy.completeWithError(.unexpected)
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldShowLoadingBeforeCallAddAccount() {
    let loadingViewSpy = LoadingViewSpy()
    let sut = makeSUT(loadingView: loadingViewSpy)
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

  func makeSignUpViewModel(
    name: String? = "any_name",
    email: String? = "email@email.com",
    password: String? = "any_password",
    passwordConfirmation: String? = "any_password"
  ) -> SignUpViewModel {
    SignUpViewModel(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation
    )
  }

  func makeRequiredAlertViewModel(fieldName: String) -> AlertViewModel {
    AlertViewModel(
      title: "Falha na validação",
      message: "O campo '\(fieldName)' é obrigatório"
    )
  }

  func makeInvalidAlertViewModel(fieldName: String) -> AlertViewModel {
    AlertViewModel(
      title: "Falha na validação",
      message: "O campo '\(fieldName)' é inválido"
    )
  }

  func makeErrorAlertViewModel(message: String) -> AlertViewModel {
    AlertViewModel(
      title: "Erro",
      message: message
    )
  }

  final class AlertViewSpy: AlertView {
    var emit: ((AlertViewModel) -> Void)?

    func showMessage(viewModel: AlertViewModel) {
      self.emit?(viewModel)
    }
    
    func observe(completion: @escaping (AlertViewModel) -> Void) {
      self.emit = completion
    }
  }

  final class EmailValidatorSpy: EmailValidator {
    var isValid = true
    var email: String?

    func isValid(_ email: String) -> Bool {
      self.email = email
      return isValid
    }

    func simulateInvalidEmail() {
      isValid = false
    }
  }

  final class AddAccountSpy: AddAccount {
    var viewModel: AddAccountModel?
    var completion: ((Result<AccountModel, DomainError>) -> Void)?

    func add(
      addAccountModel: AddAccountModel,
      completion: @escaping (Result<AccountModel, DomainError>) -> Void
    ) {
      self.completion = completion
      self.viewModel = addAccountModel
    }

    func completeWithError(_ error: DomainError) {
      completion?(.failure(error))
    }
  }

  final class LoadingViewSpy: LoadingView {
    var emit: ((LoadingViewModel) -> Void)?

    func display(viewModel: LoadingViewModel) {
      self.emit?(viewModel)
    }

    func observe(completion: @escaping (LoadingViewModel) -> Void) {
      self.emit = completion
    }
  }
}
