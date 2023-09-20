import Domain
import Foundation

public final class MockGetOdds: GetOdds {
  public init() {}

  public func get(
    completion: @escaping (Result<[Odd], DomainError>) -> Void
  ) {
    guard let url = Bundle.main.url(forResource: "GetOddsResponse", withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
      completion(.failure(.unexpected))
      return
    }
    do {
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let models = try decoder.decode([Odd].self, from: data)
      completion(.success(models))
    } catch {
      completion(.failure(.decodeFailure))
    }
  }
}
