import Foundation

public struct Bookmaker: Decodable {
  public var key: String
  public var title: String
  public var lastUpdate: Date
  public var markets: [Market]
}
