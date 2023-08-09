import Foundation
import XCTest

public extension XCTestCase {
  func checkMemoryLeak(for instance: AnyObject) {
    addTeardownBlock { [weak instance] in
      XCTAssertNil(instance)
    }
  }
}
