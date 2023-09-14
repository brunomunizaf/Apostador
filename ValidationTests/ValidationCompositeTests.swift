import XCTest
import Presentation
import Validation

final class ValidationCompositeTests: XCTestCase {
  func test_validateShouldReturnErrorIfValidationFails() {
    let validationSpy = ValidationSpy()
    let sut = makeSUT(validations: [validationSpy])
    validationSpy.simulateError("Erro 1")
    let errorMessage = sut.validate(data: ["name": "Bruno"])
    XCTAssertEqual(errorMessage, "Erro 1")
  }

  func test_validateShouldReturnCorrectMessageError() {
    let validationSpy = ValidationSpy()
    let validationSpy2 = ValidationSpy()
    let sut = makeSUT(
      validations: [
        validationSpy,
        validationSpy2
      ]
    )
    validationSpy2.simulateError("Erro 3")
    let errorMessage = sut.validate(data: ["name": "Bruno"])
    XCTAssertEqual(errorMessage, "Erro 3")
  }

  func test_validateShouldReturnTheFirstErrorMessage() {
    let validationSpy2 = ValidationSpy()
    let validationSpy3 = ValidationSpy()
    let sut = makeSUT(
      validations: [
        ValidationSpy(),
        validationSpy2,
        validationSpy3
      ]
    )
    validationSpy2.simulateError("Erro 2")
    validationSpy3.simulateError("Erro 3")
    let errorMessage = sut.validate(data: ["name": "Bruno"])
    XCTAssertEqual(errorMessage, "Erro 2")
  }

  func test_validateShouldReturnNilIfValidationSucceeds() {
    let sut = makeSUT(validations: [ValidationSpy()])
    let errorMessage = sut.validate(data: ["name": "Bruno"])
    XCTAssertNil(errorMessage)
  }

  func test_validateShouldCallValidationWithCorrectData() {
    let validationSpy = ValidationSpy()
    let sut = makeSUT(validations: [validationSpy])
    let data = ["name": "Bruno"]
    _ = sut.validate(data: data)
    XCTAssertTrue(NSDictionary(dictionary: validationSpy.data!).isEqual(to: data))
  }
}

extension ValidationCompositeTests {
  func makeSUT(validations: [ValidationSpy]) -> Validation {
    let sut = ValidationComposite(validations: validations)
    checkMemoryLeak(for: sut)
    return sut
  }
}
