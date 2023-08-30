import Domain
import Foundation
import UI

public final class SportsListComposer {
  static func composeControllerWith(getSports: GetSports) -> SportsListViewController {
    ControllerFactory.makeSportsList(getSports: getSports)
  }
}
