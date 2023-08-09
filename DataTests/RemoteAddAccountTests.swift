import Data
import Domain
import XCTest

final class RemoteAddAccountTests: XCTestCase {
  func test_addShouldCallHttpClientWithCorrectUrl() {
    let url = makeURL()
    let (sut, client) = makeSUT(url: url)
    sut.add(addAccountModel: makeAddAccountModel()) { _ in }
    XCTAssertEqual(client.urls, [url])
  }

  func test_addShouldCallHttpClientWithCorrectData() {
    let (sut, client) = makeSUT()
    let addAccountModel = makeAddAccountModel()
    sut.add(addAccountModel: addAccountModel) { _ in }
    XCTAssertEqual(client.data, addAccountModel.toData())
  }

  func test_addShouldCompleteWithErrorIfClientCompletesWithError() {
    let (sut, client) = makeSUT()
    expect(
      sut,
      completeWith: .failure(.unexpected),
      when: { client.completeWithError(.noConnectivityError) }
    )
  }

  func test_addShouldCompleteWithAccountIfClientCompletesWithValidData() {
    let (sut, client) = makeSUT()
    let expectedAccount = makeAccountModel()
    expect(
      sut,
      completeWith: .success(expectedAccount),
      when: { client.completeWithData(makeAccountModel().toData()!) }
    )
  }

  func test_addShouldCompleteWithErrorIfClientCompletesWithInvalidData() {
    let (sut, client) = makeSUT()
    expect(
      sut,
      completeWith: .failure(.decodeFailure),
      when: { client.completeWithData(makeInvalidData()) }
    )
  }

  func test_addShouldNotCompleteIfSUTHasBeenDallocated() {
    let client = HttpClientSpy()
    var result: Result<AccountModel, DomainError>?
    var sut: RemoteAddAccount? = RemoteAddAccount(url: makeURL(), httpClient: client)
    sut?.add(addAccountModel: makeAddAccountModel()) { result = $0 }
    sut = nil
    client.completeWithError(.noConnectivityError)
    XCTAssertNil(result)
  }
}

extension RemoteAddAccountTests {
  func makeSUT(
    url: URL = URL(string: "http://any-url.com")!
  ) -> (sut: RemoteAddAccount, httpClientSpy: HttpClientSpy)  {
    let httpClientSpy = HttpClientSpy()
    let sut = RemoteAddAccount(
      url: url,
      httpClient: httpClientSpy
    )
    checkMemoryLeak(for: sut)
    checkMemoryLeak(for: httpClientSpy)
    return (sut, httpClientSpy)
  }

  func expect(
    _ sut: RemoteAddAccount,
    completeWith expectedResult: Result<AccountModel, DomainError>,
    when action: () -> Void
  ) {
    let exp = expectation(description: "waiting")
    sut.add(addAccountModel: makeAddAccountModel()) { receivedResult in
      XCTAssertEqual(receivedResult, expectedResult)
      exp.fulfill()
    }
    action()
    wait(for: [exp], timeout: 1)
  }
}
