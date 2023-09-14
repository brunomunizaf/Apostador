import Validation

final class EmailValidatorSpy: EmailValidator {
  var isValid = true
  var email: String?

  func isValid(_ email: String) -> Bool {
    self.email = email
    return isValid
  }

  func simulateInvalidEmail() {
    isValid = false
  }
}
