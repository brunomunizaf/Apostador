import Domain
import Presentation

func makeSignUpViewModel(
  name: String? = "any_name",
  email: String? = "email@email.com",
  password: String? = "any_password",
  passwordConfirmation: String? = "any_password"
) -> SignUpViewModel {
  SignUpViewModel(
    name: name,
    email: email,
    password: password,
    passwordConfirmation: passwordConfirmation
  )
}

func makeSportViewModels(
  key: String = "soccer_austria_bundesliga",
  group: String = "Soccer",
  title: String = "Austrian Football Bundesliga",
  active: Bool = true,
  description: String = "Austrian Soccer",
  hasOutrights: Bool = true
) -> [SportModel] {
  var models = [SportModel]()
  for i in 1..<10 {
    models.append(
      SportModel(
        key: "\(i)-\(key)",
        group: "\(i)-\(group)",
        title: "\(i)-\(title)",
        active: active,
        description: "\(i)-\(description)",
        hasOutrights: hasOutrights
      )
    )
  }
  return models
}
