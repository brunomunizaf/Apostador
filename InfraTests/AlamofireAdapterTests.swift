import Alamofire
import Data
import Infra
import XCTest

final class AlamofireAdapterTests: XCTestCase {
  func test_postShouldMakeRequestWithValidURLAndMethod() {
    let url = makeURL()
    testRequestFor(url: url, data: makeValidData()) { request in
      XCTAssertEqual(url, request.url)
      XCTAssertNotNil(request.httpBodyStream)
      XCTAssertEqual("POST", request.httpMethod)
    }
  }

  func test_postShouldMakeRequestWithNoData() {
    testRequestFor(data: nil) { request in
      XCTAssertNil(request.httpBodyStream)
    }
  }

  func test_postShouldCompleteWithErrorWhenRequestCompletesWithError() {
    expectResult(
      .failure(.noConnectivityError),
      when: (data: nil, response: nil, error: makeError())
    )
  }

  func test_postShouldCompleteWithErrorOnAllInvalidCases() {
    expectResult(
      .failure(.noConnectivityError),
      when: (
        data: makeValidData(),
        response: makeHTTPResponse(),
        error: makeError()
      )
    )
    expectResult(
      .failure(.noConnectivityError),
      when: (
        data: makeValidData(),
        response: nil,
        error: makeError()
      )
    )
    expectResult(
      .failure(.noConnectivityError),
      when: (
        data: makeValidData(),
        response: nil,
        error: nil
      )
    )
    expectResult(
      .failure(.noConnectivityError),
      when: (
        data: nil,
        response: makeHTTPResponse(),
        error: makeError()
      )
    )
    expectResult(
      .failure(.noConnectivityError),
      when: (
        data: nil,
        response: makeHTTPResponse(),
        error: nil
      )
    )
    expectResult(
      .failure(.noConnectivityError),
      when: (
        data: nil,
        response: nil,
        error: nil
      )
    )
  }

  func test_postShouldCompleteWithDataWhenRequestCompletesWith200() {
    expectResult(
      .success(makeValidData()),
      when: (
        data: makeValidData(),
        response: makeHTTPResponse(),
        error: nil
      )
    )
  }

  func test_postShouldCompleteWithErrorRequestCompletesNon200() {
    expectResult(
      .failure(.badRequest),
      when: (
        data: makeValidData(),
        response: makeHTTPResponse(statusCode: 400),
        error: nil
      )
    )
    expectResult(
      .failure(.serverError),
      when: (
        data: makeValidData(),
        response: makeHTTPResponse(statusCode: 500),
        error: nil
      )
    )
    expectResult(
      .failure(.badRequest),
      when: (
        data: makeValidData(),
        response: makeHTTPResponse(statusCode: 450),
        error: nil
      )
    )
    expectResult(
      .failure(.badRequest),
      when: (
        data: makeValidData(),
        response: makeHTTPResponse(statusCode: 499),
        error: nil
      )
    )
    expectResult(
      .failure(.serverError),
      when: (
        data: makeValidData(),
        response: makeHTTPResponse(statusCode: 550),
        error: nil
      )
    )
    expectResult(
      .failure(.serverError),
      when: (
        data: makeValidData(),
        response: makeHTTPResponse(statusCode: 599),
        error: nil
      )
    )
    expectResult(
      .failure(.unauthorized),
      when: (
        data: makeValidData(),
        response: makeHTTPResponse(statusCode: 401),
        error: nil
      )
    )
    expectResult(
      .failure(.forbidden),
      when: (
        data: makeValidData(),
        response: makeHTTPResponse(statusCode: 403),
        error: nil
      )
    )
  }

  func test_postShouldCompleteWithNoDataWhenRequestCompletesWith204() {
    expectResult(
      .success(nil),
      when: (
        data: nil,
        response: makeHTTPResponse(statusCode: 204),
        error: nil
      )
    )
    expectResult(
      .success(nil),
      when: (
        data: makeEmptyData(),
        response: makeHTTPResponse(statusCode: 204),
        error: nil
      )
    )
    expectResult(
      .success(nil),
      when: (
        data: makeValidData(),
        response: makeHTTPResponse(statusCode: 204),
        error: nil
      )
    )
  }
}

extension AlamofireAdapterTests {
  func makeSUT() -> AlamofireAdapter {
    let configuration = URLSessionConfiguration.default
    configuration.protocolClasses = [URLProtocolStub.self]
    let session = Session(configuration: configuration)
    let sut = AlamofireAdapter(session: session)
    checkMemoryLeak(for: sut)
    return sut
  }

  func testRequestFor(
    url: URL = makeURL(),
    data: Data?,
    action: @escaping (URLRequest) -> Void
  ) {
    let sut = makeSUT()
    let exp = expectation(description: "waiting")
    sut.post(to: url, with: data) { _ in
      exp.fulfill()
    }
    var request: URLRequest?
    URLProtocolStub.observeRequest {
      request = $0
    }
    wait(for: [exp], timeout: 1)
    action(request!)
  }

  func expectResult(
    _ expectedResult: Result<Data?, HttpError>,
    when stub: (data: Data?, response: HTTPURLResponse?, error: Error?)
  ) {
    let sut = makeSUT()
    let exp = expectation(description: "waiting")
    URLProtocolStub.simulate(
      data: stub.data,
      response: stub.response,
      error: stub.error
    )
    sut.post(
      to: makeURL(),
      with: makeValidData()
    ) { receivedResult in
      switch (expectedResult, receivedResult) {
      case (.failure(let expectedError), .failure(let receivedError)):
        XCTAssertEqual(expectedError, receivedError)
      case (.success(let expectedData), .success(let receivedData)):
        XCTAssertEqual(expectedData, receivedData)
      default:
        XCTFail("Expected \(expectedResult) but got \(receivedResult) instead")
      }
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1)
  }
}
