import Foundation

public struct Odd: Decodable {
  public var id: String
  public var sportKey: String
  public var sportTitle: String
  public var commenceTime: String
  public var homeTeam: String
  public var awayTeam: String
  public var bookmakers: [Bookmaker]
}

//public struct Odd: Decodable {
//  public var id: String
//  public var sportKey: String
//  public var sportTitle: String
//  public var commenceTime: Date
//  public var homeTeam: String
//  public var awayTeam: String
//  public var bookmakers: [Bookmaker]
//}
