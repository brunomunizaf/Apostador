import UIKit

extension UIViewController {
  func hideKeyboardOnTap() {
    let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    gesture.cancelsTouchesInView = true
    view.addGestureRecognizer(gesture)
  }

  @objc private func hideKeyboard() {
    view.endEditing(true)
  }
}
