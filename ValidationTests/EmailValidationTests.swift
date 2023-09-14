import XCTest
import Presentation
import Validation

final class EmailValidationTests: XCTestCase {
  func test_validateShouldReturnErrorIfInvalidEmailIsProvided() {
    let emailValidatorSpy = EmailValidatorSpy()
    let sut = makeSUT(
      fieldName: "email",
      fieldLabel: "Email",
      emailValidator: emailValidatorSpy
    )
    emailValidatorSpy.simulateInvalidEmail()
    let errorMessage = sut.validate(data: ["email": "invalid_email@gmail.com"])
    XCTAssertEqual(errorMessage, "O campo Email é inválido")
  }

  func test_validateShouldReturnErrorWithCorrectFieldLabel() {
    let emailValidatorSpy = EmailValidatorSpy()
    let sut = makeSUT(
      fieldName: "email",
      fieldLabel: "Email2",
      emailValidator: emailValidatorSpy
    )
    emailValidatorSpy.simulateInvalidEmail()
    let errorMessage = sut.validate(data: ["email": "invalid_email@gmail.com"])
    XCTAssertEqual(errorMessage, "O campo Email2 é inválido")
  }

  func test_validateShouldReturnNilIfValidEmailIsProvided() {
    let sut = makeSUT(
      fieldName: "email",
      fieldLabel: "Email2",
      emailValidator: EmailValidatorSpy()
    )
    let errorMessage = sut.validate(data: ["email": "valid_email@gmail.com"])
    XCTAssertNil(errorMessage)
  }

  /// N.B: THIS TEST IS INCORRECT
  ///
  func test_validateShouldReturnNilIfNoDataIsProvided() {
    let sut = makeSUT(
      fieldName: "email",
      fieldLabel: "Email",
      emailValidator: EmailValidatorSpy()
    )
    let errorMessage = sut.validate(data: nil)
    XCTAssertEqual(errorMessage, "O campo Email é inválido")
  }
}

extension EmailValidationTests {
  func makeSUT(
    fieldName: String,
    fieldLabel: String,
    emailValidator: EmailValidatorSpy
  ) -> Validation {
    let sut = EmailValidation(
      fieldName: fieldName,
      fieldLabel: fieldLabel,
      emailValidator: emailValidator
    )
    checkMemoryLeak(for: sut)
    return sut
  }
}
