import Foundation

public extension Data {
  func toModel<T: Decodable>() -> T? {
    try? JSONDecoder().decode(T.self, from: self)
  }

  func toJSON() -> [String: Any]? {
    try? JSONSerialization.jsonObject(with: self, options: .fragmentsAllowed) as? [String: Any]
  }
}
