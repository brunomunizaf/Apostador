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

  public func fetch(_ completion: @escaping ([SportsListViewModel]) -> Void) {
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
      case .success(let sports):
        let viewModels = Dictionary(
          grouping: sports,
          by: \.group
        ).map { key, value in
          SportsListViewModel(
            title: key,
            sports: value.sorted(by: { $0.title < $1.title })
          )
        }.sorted(by: { $0.title < $1.title })
        completion(viewModels)
      }
      self.loadingView.display(viewModel: .init(isLoading: false))
    }
  }
}
