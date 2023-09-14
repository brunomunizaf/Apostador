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
