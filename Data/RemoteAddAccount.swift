import Domain
import Foundation

public final class RemoteAddAccount: AddAccount {
  private let url: URL
  private let httpClient: HttpPostClient

  public init(
    url: URL,
    httpClient: HttpPostClient
  ) {
    self.url = url
    self.httpClient = httpClient
  }

  public func add(
    addAccountModel: AddAccountModel,
    completion: @escaping (Result<AccountModel, DomainError>) -> Void
  ) {
    httpClient.post(
      to: url,
      with: addAccountModel.toData()
    ) { [weak self] in
      guard self != nil else { return }

      switch $0 {
      case .success(let data):
        guard let model: AccountModel = data?.toModel() else {
          completion(.failure(.decodeFailure))
          return
        }
        completion(.success(model))

      case .failure(_):
        completion(.failure(.unexpected))
      }
    }
  }
}
