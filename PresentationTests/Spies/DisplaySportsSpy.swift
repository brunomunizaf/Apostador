import Domain

final class DisplaySportsSpy: DisplaySports {
  var didDisplay: [SportModel]?

  func display(_ models: [SportModel]) {
    self.didDisplay = models
  }
}
