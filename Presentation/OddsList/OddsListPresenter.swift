import Domain

public final class OddsListPresenter {
  private let getOdds: GetOdds
  private let alertView: AlertView
  private let loadingView: LoadingView

  public init(
    getOdds: GetOdds,
    alertView: AlertView,
    loadingView: LoadingView
  ) {
    self.getOdds = getOdds
    self.alertView = alertView
    self.loadingView = loadingView
  }

  public func fetch(_ completion: @escaping ([Odd]) -> Void) {
    loadingView.display(
      viewModel: .init(
        isLoading: true
      )
    )
    getOdds.get { [weak self] in
      guard let self else { return }

      switch $0 {
      case .failure(_):
        self.alertView.showMessage(
          viewModel: AlertViewModel(
            title: "Erro",
            message: "Algo inesperado aconteceu, tente novamente em instantes."
          )
        )
      case .success(let odds):
        completion(odds)
      }
      self.loadingView.display(viewModel: .init(isLoading: false))
    }
  }
}
