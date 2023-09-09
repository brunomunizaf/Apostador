import Main
import UI
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
