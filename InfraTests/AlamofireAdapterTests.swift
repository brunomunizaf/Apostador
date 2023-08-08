import Alamofire
import Data
import XCTest

final class AlamofireAdapter {
  private let session: Session

  init(session: Session = .default) {
    self.session = session
  }

  func post(to url: URL, with data: Data?) {
    session
      .request(
        url,
        method: .post,
        parameters: data?.toJSON(),
        encoding: JSONEncoding.default
      )
      .resume()
  }
}

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
}

final class URLProtocolStub: URLProtocol {
  static var emit: ((URLRequest) -> Void)?

  static func observeRequest(completion: @escaping (URLRequest) -> Void) {
    URLProtocolStub.emit = completion
  }

  override func stopLoading() {}
  override class func canInit(with request: URLRequest) -> Bool { true }
  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

  override func startLoading() {
    URLProtocolStub.emit?(request)
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
    sut.post(to: url, with: data)
    URLProtocolStub.observeRequest { request in
      action(request)
      exp.fulfill()
    }
    wait(for: [exp], timeout: 1)
  }
}
