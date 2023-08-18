import UI

final class SignupFactory {
  static func makeController() -> SignUpViewController {
    SignUpViewController.instantiate()
  }
}
