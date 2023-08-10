import Presentation
import XCTest
@testable import UI

final class SignUpViewControllerTests: XCTestCase {
  func test_loadingIsHiddenOnStart() {
    XCTAssertEqual(makeSUT().loadingIndicator?.isAnimating, false)
  }

  func test_sutImplementsLoadingView() {
    XCTAssertNotNil(makeSUT() as LoadingView)
  }

  func test_sutImplementsAlertView() {
    XCTAssertNotNil(makeSUT() as AlertView)
  }

  func test_saveButtonCallsSignUpOnTap() {
    var signUpViewModel: SignUpViewModel?
    let sut = makeSUT {
      signUpViewModel = $0
    }
    sut.signUpButton?.simulateTap()
    let name = sut.nameTextField?.text
    let email = sut.emailTextField?.text
    let password = sut.passwordTextField?.text
    let confirmPassword = sut.confirmPasswordTextField?.text

    XCTAssertEqual(signUpViewModel, .init(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: confirmPassword
    ))
  }
}

extension SignUpViewControllerTests {
  func makeSUT(
    signUpSpy: ((SignUpViewModel) -> Void)? = nil
  ) -> SignUpViewController {
    let sut = SignUpViewController.instantiate()
    sut.signUp = signUpSpy
    sut.loadViewIfNeeded()
    return sut
  }
}
