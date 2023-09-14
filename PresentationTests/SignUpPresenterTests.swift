import Domain
import Presentation
import XCTest

final class SignUpPresenterTests: XCTestCase {
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
        $0, AlertViewModel(
          title: "Erro",
          message: "Algo inesperado aconteceu, tente novamente em instantes"
        )
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
      XCTAssertEqual($0, AlertViewModel(title: "Sucesso", message: "Conta criada com sucesso."))
      exp.fulfill()
    }
    sut.signUp(viewModel: makeSignUpViewModel())
    addAccountSpy.completeWithAccount(makeAccountModel())
    wait(for: [exp], timeout: 1)
  }

  func test_signUpShouldCallValidationWithCorrectValues() {
    let validationSpy = ValidationSpy()
    let sut = makeSUT(validation: validationSpy)
    let viewModel = makeSignUpViewModel()
    sut.signUp(viewModel: viewModel)
    XCTAssertTrue(
      NSDictionary(
        dictionary: validationSpy.data!
      ).isEqual(
        to: viewModel.toJSON()!
      )
    )
  }

  func test_signUpShouldShowErrorMessageIfValidationFails() {
    let alertViewSpy = AlertViewSpy()
    let validationSpy = ValidationSpy()
    let sut = makeSUT(
      alertView: alertViewSpy,
      validation: validationSpy
    )
    let exp = expectation(description: "waiting")
    alertViewSpy.observe { viewModel in
      XCTAssertEqual(
        viewModel,
        AlertViewModel(
          title: "Falha na validação",
          message: "Erro"
        )
      )
      exp.fulfill()
    }
    validationSpy.simulateError()
    sut.signUp(viewModel: makeSignUpViewModel())
    wait(for: [exp], timeout: 1)
  }
}

extension SignUpPresenterTests {
  func makeSUT(
    alertView: AlertViewSpy = .init(),
    loadingView: LoadingViewSpy = .init(),
    addAccount: AddAccountSpy = .init(),
    validation: ValidationSpy = .init()
  ) -> SignUpPresenter {
    let sut = SignUpPresenter(
      alertView: alertView,
      loadingView: loadingView,
      addAccount: addAccount,
      validation: validation
    )
    addTeardownBlock { [weak sut] in
      XCTAssertNil(sut)
    }
    return sut
  }
}
