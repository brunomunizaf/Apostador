import Domain

public final class SignUpPresenter {
  private let alertView: AlertView
  private let addAccount: AddAccount
  private let loadingView: LoadingView
  private let emailValidator: EmailValidator

  public init(
    alertView: AlertView,
    emailValidator: EmailValidator,
    loadingView: LoadingView,
    addAccount: AddAccount
  ) {
    self.alertView = alertView
    self.addAccount = addAccount
    self.loadingView = loadingView
    self.emailValidator = emailValidator
  }

  public func signUp(viewModel: SignUpViewModel) {
    if let message = validate(viewModel: viewModel) {
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

  private func validate(viewModel: SignUpViewModel) -> String? {
    if viewModel.name == nil || viewModel.name!.isEmpty {
      return "O campo 'nome' é obrigatório"
    } else if viewModel.email == nil || viewModel.email!.isEmpty {
      return "O campo 'email' é obrigatório"
    } else if viewModel.password == nil || viewModel.password!.isEmpty {
      return "O campo 'senha' é obrigatório"
    } else if viewModel.passwordConfirmation == nil || viewModel.passwordConfirmation!.isEmpty {
      return "O campo 'confirmação de senha' é obrigatório"
    } else if viewModel.password != viewModel.passwordConfirmation {
      return "O campo 'confirmação de senha' é inválido"
    } else if !emailValidator.isValid(viewModel.email!) {
      return "O campo 'email' é inválido"
    }
    return nil
  }
}
