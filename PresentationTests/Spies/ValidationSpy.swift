public final class ValidationSpy: Validation {
  public var data: [String: Any]?
  public var errorMessage: String?

  public func validate(data: [String : Any]?) -> String? {
    self.data = data
    return errorMessage
  }

  public func simulateError() {
    self.errorMessage = "Erro"
  }
}
