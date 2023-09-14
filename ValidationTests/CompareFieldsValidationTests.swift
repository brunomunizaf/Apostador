import Presentation
import Validation
import XCTest

final class CompareFieldsValidationTests: XCTestCase {
  func test_validateShouldReturnErrorIfComparationFails() {
    let sut = makeSUT(
      fieldName: "password",
      fieldLabel: "Senha",
      fieldNameToCompare: "passwordConfirmation"
    )
    let errorMessage = sut.validate(
      data: [
        "password": "123",
        "passwordConfirmation": "1234"
      ]
    )
    XCTAssertEqual(errorMessage, "O campo Senha é inválido")
  }

  func test_validateShouldReturnErrorIfFieldIsNotProvided() {
    let sut = makeSUT(
      fieldName: "password",
      fieldLabel: "Senha",
      fieldNameToCompare: "passwordConfirmation"
    )
    let errorMessage = sut.validate(
      data: [
        "password": "123",
        "passwordConfirmation": "1234"
      ]
    )
    XCTAssertEqual(errorMessage, "O campo Senha é inválido")
  }

  func test_validateShouldReturnNilIfComparationSucceeds() {
    let sut = makeSUT(
      fieldName: "password",
      fieldLabel: "Confirmar Senha",
      fieldNameToCompare: "passwordConfirmation"
    )
    let errorMessage = sut.validate(
      data: [
        "password": "123",
        "passwordConfirmation": "123"
      ]
    )
    XCTAssertNil(errorMessage)
  }
}

extension CompareFieldsValidationTests {
  func makeSUT(
    fieldName: String,
    fieldLabel: String,
    fieldNameToCompare: String
  ) -> Validation {
    let sut = CompareFieldsValidation(
      fieldName: fieldName,
      fieldLabel: fieldLabel,
      fieldNameToCompare: fieldNameToCompare
    )
    checkMemoryLeak(for: sut)
    return sut
  }
}
