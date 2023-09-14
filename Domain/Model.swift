import Foundation

public protocol Model: Codable, Equatable {}

public extension Model {
  func toData() -> Data? {
    try? JSONEncoder().encode(self)
  }

  func toJSON() -> [String: Any]? {
    guard let data = toData() else { return nil }
    return try? JSONSerialization.jsonObject(
      with: data,
      options: .fragmentsAllowed
    ) as? [String: Any]
  }
}
