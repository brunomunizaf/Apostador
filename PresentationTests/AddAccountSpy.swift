import Domain

final class AddAccountSpy: AddAccount {
  var viewModel: AddAccountModel?
  var completion: ((Result<AccountModel, DomainError>) -> Void)?

  func add(
    addAccountModel: AddAccountModel,
    completion: @escaping (Result<AccountModel, DomainError>) -> Void
  ) {
    self.completion = completion
    self.viewModel = addAccountModel
  }

  func completeWithError(_ error: DomainError) {
    completion?(.failure(error))
  }

  func completeWithAccount(_ model: AccountModel) {
    completion?(.success(model))
  }
}
