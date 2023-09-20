import Domain
import UI

public final class DetailsComposer {
  public static func composeControllerWith(
    odd: Odd
  ) -> DetailsViewController {
    let controller = DetailsViewController.instantiate()
    controller.model = odd
    return controller
  }
}
