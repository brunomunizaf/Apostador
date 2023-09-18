import Domain
import Foundation
import Presentation
import UI

public final class SportsListComposer {
  public static func composeControllerWith(
    getSports: GetSports
  ) -> SportsListViewController {
    let controller = SportsListViewController.instantiate()
    let presenter = SportsListPresenter(
      alertView: controller,
      getSports: getSports,
      loadingView: controller
    )
    controller.push = { sport in
      controller.navigationController?.pushViewController(
        OddsListComposer.composeControllerWith(
          sport: sport,
          getOdds: UseCaseFactory.makeRemoteGetOdds(
            sportKey: sport.key,
            apiKey: Environment.variable(.apiKey)
          )
        ),
        animated: true
      )
    }
    controller.fetch = presenter.fetch
    return controller
  }
}
