import Foundation

public struct Market: Decodable {
  public var key: String
  public var lastUpdate: String
  public var outcomes: [Outcome]
}
