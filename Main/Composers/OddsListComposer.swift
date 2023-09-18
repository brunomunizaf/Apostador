import Domain
import Foundation
import Presentation
import UI

public final class OddsListComposer {
  public static func composeControllerWith(
    sport: Sport,
    getOdds: GetOdds
  ) -> OddsListViewController {
    let controller = OddsListViewController.instantiate()
    let presenter = OddsListPresenter(
      getOdds: getOdds,
      alertView: controller,
      loadingView: controller
    )
    controller.fetch = presenter.fetch
    return controller
  }
}
