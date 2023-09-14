import Foundation

public protocol EmailValidator {
  func isValid(_ email: String) -> Bool
}
