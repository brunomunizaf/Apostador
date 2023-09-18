import Foundation

public struct HistoricalOdds: Decodable {
  public var timestamp: Date
  public var previousTimestamp: Date
  public var nextTimestamp: Date
  public var data: [Odd]
}
