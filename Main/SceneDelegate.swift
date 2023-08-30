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
    window?.rootViewController = SportsListComposer.composeControllerWith(
      getSports: UseCaseFactory.makeRemoteGetSports(apiKey: "3764bb90a173e8b6d9daf1eb29900d01")
    )
    window?.makeKeyAndVisible()
  }
}
