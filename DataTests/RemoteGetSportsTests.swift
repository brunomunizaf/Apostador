import Data
import Domain
import XCTest

final class RemoteGetSportsTests: XCTestCase {
  func test_getShouldCallHttpClientWithCorrectUrl() {
    let url = makeURL()
    let (sut, client) = makeSUT(url: url)
    sut.get { _ in }
    XCTAssertEqual(client.urls, [url])
  }

  func test_getShouldCompleteWithErrorIfClientCompletesWithError() {
    let (sut, client) = makeSUT()
    expect(
      sut,
      completeWith: .failure(.unexpected),
      when: { client.completeWithError(.noConnectivityError) }
    )
  }

  func test_getShouldCompleteWithAccountIfClientCompletesWithValidData() {
    let (sut, client) = makeSUT()
    let expectedSports = [makeSportModel()]
    let data = try! JSONEncoder().encode([makeSportModel()])
    expect(
      sut,
      completeWith: .success(expectedSports),
      when: { client.completeWithData(data) }
    )
  }

  func test_getShouldCompleteWithErrorIfClientCompletesWithInvalidData() {
    let (sut, client) = makeSUT()
    expect(
      sut,
      completeWith: .failure(.decodeFailure),
      when: { client.completeWithData(makeInvalidData()) }
    )
  }

  func test_getShouldNotCompleteIfSUTHasBeenDallocated() {
    let client = HttpClientSpy()
    var result: Result<[SportModel], DomainError>?
    var sut: RemoteGetSports? = RemoteGetSports(url: makeURL(), httpClient: client)
    sut?.get { result = $0 }
    sut = nil
    client.completeWithError(.noConnectivityError)
    XCTAssertNil(result)
  }
}

extension RemoteGetSportsTests {
  func makeSUT(
    url: URL = URL(string: "http://any-url.com")!
  ) -> (sut: RemoteGetSports, httpClientSpy: HttpClientSpy)  {
    let httpClientSpy = HttpClientSpy()
    let sut = RemoteGetSports(
      url: url,
      httpClient: httpClientSpy
    )
    checkMemoryLeak(for: sut)
    checkMemoryLeak(for: httpClientSpy)
    return (sut, httpClientSpy)
  }

  func expect(
    _ sut: RemoteGetSports,
    completeWith expectedResult: Result<[SportModel], DomainError>,
    when action: () -> Void
  ) {
    let exp = expectation(description: "waiting")
    sut.get { receivedResult in
      XCTAssertEqual(receivedResult, expectedResult)
      exp.fulfill()
    }
    action()
    wait(for: [exp], timeout: 1)
  }
}
