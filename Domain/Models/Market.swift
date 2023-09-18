import Foundation

public struct Market: Decodable {
  public var key: String
  public var lastUpdate: Date
  public var outcomes: [Outcome]
}
