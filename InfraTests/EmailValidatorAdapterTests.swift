import Infra
import XCTest

final class EmailValidatorAdapterTests: XCTestCase {
  func test_invalidEmails() {
    let sut = makeSUT()
    XCTAssertFalse(sut.isValid("rr"))
    XCTAssertFalse(sut.isValid("rr@"))
    XCTAssertFalse(sut.isValid("rr@r"))
    XCTAssertFalse(sut.isValid("rr@rr"))
    XCTAssertFalse(sut.isValid("rr@rr."))
    XCTAssertFalse(sut.isValid("@rr.com"))
  }

  func test_validEmails() {
    let sut = makeSUT()
    XCTAssertTrue(sut.isValid("bruno@gmail.com"))
    XCTAssertTrue(sut.isValid("bruno@hotmail.com"))
  }
}

extension EmailValidatorAdapterTests {
  func makeSUT() -> EmailValidatorAdapter {
    EmailValidatorAdapter()
  }
}
