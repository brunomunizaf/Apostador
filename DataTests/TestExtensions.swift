import Foundation
import XCTest

extension XCTestCase {
  func checkMemoryLeak(for instance: AnyObject) {
    addTeardownBlock { [weak instance] in
      XCTAssertNil(instance)
    }
  }
}
