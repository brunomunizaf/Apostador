import Domain

final class DisplaySportsSpy: DisplaySports {
  var emit: (([SportModel]) -> Void)?

  func display(_ models: [SportModel]) {
    self.emit?(models)
  }

  func observe(completion: @escaping ([SportModel]) -> Void) {
    self.emit = completion
  }
}
