import Presentation

final class ValidationSpy: Validation {
  var data: [String: Any]?
  var errorMessage: String?

  func validate(data: [String : Any]?) -> String? {
    self.data = data
    return errorMessage
  }

  func simulateError(_ errorMessage: String) {
    self.errorMessage = errorMessage
  }
}
