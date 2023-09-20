import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)
    let controller = SportsListComposer.composeControllerWith(
      getSports: UseCaseFactory.makeGetSports(
        apiKey: Environment.variable(.apiKey)
      )
    )
    window?.rootViewController = UINavigationController(
      rootViewController: controller
    )
    window?.makeKeyAndVisible()
  }
}
