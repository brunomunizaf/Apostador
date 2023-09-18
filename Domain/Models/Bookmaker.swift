import Foundation

public struct Bookmaker: Decodable {
  public var key: String
  public var title: String
  public var lastUpdate: String
  public var markets: [Market]
}
