import Domain

public final class SignUpPresenter {
  private let alertView: AlertView
  private let addAccount: AddAccount
  private let loadingView: LoadingView
  private let validation: Validation

  public init(
    alertView: AlertView,
    loadingView: LoadingView,
    addAccount: AddAccount,
    validation: Validation
  ) {
    self.alertView = alertView
    self.addAccount = addAccount
    self.validation = validation
    self.loadingView = loadingView
  }

  public func signUp(viewModel: SignUpViewModel) {
    if let message = validation.validate(data: viewModel.toJSON()) {
      alertView.showMessage(
        viewModel: AlertViewModel(
          title: "Falha na validação",
          message: message
        )
      )
    } else {
      loadingView.display(
        viewModel: .init(
          isLoading: true
        )
      )
      addAccount.add(
        addAccountModel: SignUpMapper.toAddAccountModel(
          viewModel: viewModel
        )
      ) { [weak self] in
        guard let self else { return }

        switch $0 {
        case .failure:
          self.alertView.showMessage(
            viewModel: AlertViewModel(
              title: "Erro",
              message: "Algo inesperado aconteceu, tente novamente em instantes"
            )
          )
        case .success:
          self.alertView.showMessage(
            viewModel: AlertViewModel(
              title: "Sucesso",
              message: "Conta criada com sucesso."
            )
          )
        }
        self.loadingView.display(viewModel: .init(isLoading: false))
      }
    }
  }
}
