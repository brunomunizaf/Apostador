import Domain

public final class SportsListPresenter {
  private let alertView: AlertView
  private let getSports: GetSports
  private let loadingView: LoadingView

  public init(
    alertView: AlertView,
    getSports: GetSports,
    loadingView: LoadingView
  ) {
    self.alertView = alertView
    self.getSports = getSports
    self.loadingView = loadingView
  }

  public func fetch() {
    loadingView.display(
      viewModel: .init(
        isLoading: true
      )
    )
    getSports.get { [weak self] in
      guard let self else { return }

      switch $0 {
      case .failure(_):
        self.alertView.showMessage(
          viewModel: AlertViewModel(
            title: "Erro",
            message: "Algo inesperado aconteceu, tente novamente em instantes."
          )
        )
      case .success:
        break
      }
      self.loadingView.display(viewModel: .init(isLoading: false))
    }
  }
}
