import Domain

final class AddAccountSpy: AddAccount {
  var viewModel: AddAccountModel?
  var completion: ((Result<Account, DomainError>) -> Void)?

  func add(
    accountModel: AddAccountModel,
    completion: @escaping (Result<Account, DomainError>) -> Void
  ) {
    self.completion = completion
    self.viewModel = accountModel
  }

  func completeWithError(_ error: DomainError) {
    completion?(.failure(error))
  }

  func completeWithAccount(_ model: Account) {
    completion?(.success(model))
  }
}
