import Domain
import Foundation

public final class MockGetSports: GetSports {
  public init() {}

  public func get(
    completion: @escaping (Result<[Sport], DomainError>) -> Void
  ) {
    guard let url = Bundle.main.url(forResource: "GetSportsResponse", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
      completion(.failure(.unexpected))
      return
    }
    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let models = try decoder.decode([Sport].self, from: data)
      completion(.success(models))
    } catch {
      completion(.failure(.decodeFailure))
    }
  }
}
