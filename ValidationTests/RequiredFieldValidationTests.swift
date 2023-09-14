import Presentation
import Validation
import XCTest

final class RequiredFieldValidationTests: XCTestCase {
  func test_validateShouldReturnErrorIfFieldIsNotProvided() {
    let sut = makeSUT(
      fieldName: "email",
      fieldLabel: "Email"
    )
    let errorMessage = sut.validate(data: ["name": "Bruno"])
    XCTAssertEqual(errorMessage, "O campo Email é obrigatório")
  }

  func test_validateShouldReturnErrorWithCorrectFieldLabel() {
    let sut = makeSUT(
      fieldName: "age",
      fieldLabel: "Idade"
    )
    let errorMessage = sut.validate(data: ["name": "Bruno"])
    XCTAssertEqual(errorMessage, "O campo Idade é obrigatório")
  }

  func test_validateShouldReturnNilIfFieldIsProvidedCorrectly() {
    let sut = makeSUT(
      fieldName: "email",
      fieldLabel: "Email"
    )
    let errorMessage = sut.validate(data: ["email": "bruno@gmail.com"])
    XCTAssertNil(errorMessage)
  }

  func test_validateShouldReturnNilIfNoDataIsProvided() {
    let sut = makeSUT(
      fieldName: "email",
      fieldLabel: "Email"
    )
    let errorMessage = sut.validate(data: nil)
    XCTAssertEqual(errorMessage, "O campo Email é obrigatório")
  }
}

extension RequiredFieldValidationTests {
  func makeSUT(
    fieldName: String,
    fieldLabel: String
  ) -> Validation {
    let sut = RequiredFieldValidation(
      fieldName: fieldName,
      fieldLabel: fieldLabel
    )
    checkMemoryLeak(for: sut)
    return sut
  }
}
