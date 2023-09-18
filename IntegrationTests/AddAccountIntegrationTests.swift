import Data
import Domain
import Infra
import XCTest

final class AddAccountIntegrationTests: XCTestCase {
  /// N.B: This test is failing but it
  /// shouldn't be pinging the actual API
  ///
  func _test_addAccount() {
    let alamofireAdapter = AlamofireAdapter()
    let addAccountModel = AddAccountModel(
      name: "Bruno Muniz",
      email: "bruno@gmail.com",
      password: "secret",
      passwordConfirmation: "secret"
    )
    let exp = expectation(description: "waiting")
    let sut = RemoteAddAccount(
      url: URL(string: "https://clean-node-api.herokuapp.com/api/signup")!,
      httpClient: alamofireAdapter
    )
    sut.add(accountModel: addAccountModel) { result in
      switch result {
      case .success(let account):
        XCTAssertNotNil(account.id)
        XCTAssertEqual(account.name, addAccountModel.name)
        XCTAssertEqual(account.email, addAccountModel.email)

      case .failure(_):
        XCTFail("Expected success but got \(result) instead")
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 5)
  }

  func test_addAccountFailure() {
    let alamofireAdapter = AlamofireAdapter()
    let addAccountModel = AddAccountModel(
      name: "Bruno Muniz",
      email: "bruno@gmail.com",
      password: "secret",
      passwordConfirmation: "secret2"
    )
    let exp = expectation(description: "waiting")
    let sut = RemoteAddAccount(
      url: URL(string: "https://clean-node-api.herokuapp.com/api/signup")!,
      httpClient: alamofireAdapter
    )
    sut.add(accountModel: addAccountModel) { result in
      switch result {
      case .success(_):
        XCTFail("Expected error but got \(result) instead")
      case .failure(let error):
        XCTAssertEqual(error, .unexpected)
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 5)
  }
}
