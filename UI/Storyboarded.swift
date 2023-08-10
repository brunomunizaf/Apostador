import UIKit

public protocol Storyboarded {
  static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
  public static func instantiate() -> Self {
    let viewControllerName = String(describing: self)
    let storyboardName = viewControllerName.components(separatedBy: "ViewController")[0]
    let bundle = Bundle(for: Self.self)
    let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
    return storyboard.instantiateViewController(withIdentifier: viewControllerName) as! Self
  }
}
