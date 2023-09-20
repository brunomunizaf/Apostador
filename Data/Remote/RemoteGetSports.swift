import Domain
import Foundation

public final class RemoteGetSports: GetSports {
  private let url: URL
  private let httpClient: HttpGetClient

  public init(
    url: URL,
    httpClient: HttpGetClient
  ) {
    self.url = url
    self.httpClient = httpClient
  }

  public func get(
    completion: @escaping (Result<[Sport], DomainError>) -> Void
  ) {
    httpClient.get(from: url) { [weak self] in
      guard self != nil else { return }

      switch $0 {
      case .success(let data):
        guard let models: [Sport] = data?.toModel() else {
          completion(.failure(.decodeFailure))
          return
        }
        completion(.success(models))

      case .failure(_):
        completion(.failure(.unexpected))
      }
    }
  }
}
