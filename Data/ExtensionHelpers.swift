import Foundation

public extension Data {
  func toModel<T: Decodable>() -> T? {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try? decoder.decode(T.self, from: self)
  }

  func toJSON() -> [String: Any]? {
    try? JSONSerialization.jsonObject(
      with: self,
      options: .fragmentsAllowed
    ) as? [String: Any]
  }
}
