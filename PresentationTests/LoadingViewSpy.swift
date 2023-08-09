import Presentation

final class LoadingViewSpy: LoadingView {
  var emit: ((LoadingViewModel) -> Void)?

  func display(viewModel: LoadingViewModel) {
    self.emit?(viewModel)
  }

  func observe(completion: @escaping (LoadingViewModel) -> Void) {
    self.emit = completion
  }
}
