import Presentation

final class AlertViewSpy: AlertView {
  var emit: ((AlertViewModel) -> Void)?

  func showMessage(viewModel: AlertViewModel) {
    self.emit?(viewModel)
  }

  func observe(completion: @escaping (AlertViewModel) -> Void) {
    self.emit = completion
  }
}
