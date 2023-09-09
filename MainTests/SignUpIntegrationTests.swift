import Main
import XCTest

final class SignUpIntegrationTests: XCTestCase {
  func test_uiPresentationIntegration() {
    debugPrint(Environment.variable(.apiBaseURL))
    let sut = SignUpComposer.composeControllerWith(
      addAccount: AddAccountSpy()
    )
    checkMemoryLeak(for: sut)
  }
}
