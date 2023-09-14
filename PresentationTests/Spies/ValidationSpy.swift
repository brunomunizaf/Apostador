public final class ValidationSpy: Validation {
  public var data: [String: Any]?
  public var errorMessage: String?

  public init(
    data: [String : Any]? = nil,
    errorMessage: String? = nil
  ) {
    self.data = data
    self.errorMessage = errorMessage
  }

  public func validate(data: [String : Any]?) -> String? {
    self.data = data
    return errorMessage
  }

  public func simulateError() {
    self.errorMessage = "Erro"
  }
}
