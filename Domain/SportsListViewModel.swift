public struct SportsListViewModel {
  public let title: String
  public let sports: [Sport]

  public init(
    title: String,
    sports: [Sport]
  ) {
    self.title = title
    self.sports = sports
  }
}
