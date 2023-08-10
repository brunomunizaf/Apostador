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
    var callsCount = 0
    let sut = makeSUT { _ in
      callsCount += 1
    }
    sut.signUpButton?.simulateTap()
    XCTAssertEqual(callsCount, 1)
  }
}

extension SignUpViewControllerTests {
  func makeSUT(
    signUpSpy: ((SignUpViewModel) -> Void)? = nil
  ) -> SignUpViewController {
    let sb = UIStoryboard(
      name: "SignUp",
      bundle: Bundle(for: SignUpViewController.self)
    )
    let sut = sb.instantiateViewController(
      withIdentifier: "SignUpViewController"
    ) as! SignUpViewController

    sut.signUp = signUpSpy
    sut.loadViewIfNeeded()
    return sut
  }
}

extension UIControl {
  func simulate(event: UIControl.Event) {
    allTargets.forEach { target in
      actions(
        forTarget: target,
        forControlEvent: event
      )?.forEach{ action in
        (target as NSObject).perform(Selector(action))
      }
    }
  }

  func simulateTap() {
    simulate(event: .touchUpInside)
  }
}
