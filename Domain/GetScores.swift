import Foundation

public protocol GetScores {
  func get(completion: @escaping (Result<ScoresResponse, DomainError>) -> Void)
}

public struct ScoresResponse: Decodable {
  public var id: String
  public var sportKey: String
  public var sportTitle: String
  public var commenceTime: String
  public var completed: Bool
  public var homeTeam: String
  public var awayTeam: String
  public var scores: [Score]?
  public var lastUpdate: Date?
}
