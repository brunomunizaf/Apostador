import Foundation

final class URLProtocolStub: URLProtocol {
  static var data: Data?
  static var error: Error?
  static var response: HTTPURLResponse?
  static var emit: ((URLRequest) -> Void)?

  static func simulate(
    data: Data?,
    response: HTTPURLResponse?,
    error: Error?
  ) {
    URLProtocolStub.data = data
    URLProtocolStub.error = error
    URLProtocolStub.response = response
  }

  static func observeRequest(completion: @escaping (URLRequest) -> Void) {
    URLProtocolStub.emit = completion
  }

  override func stopLoading() {}
  override class func canInit(with request: URLRequest) -> Bool { true }
  override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

  override func startLoading() {
    URLProtocolStub.emit?(request)

    if let data = URLProtocolStub.data {
      client?.urlProtocol(self, didLoad: data)
    }
    if let error = URLProtocolStub.error {
      client?.urlProtocol(self, didFailWithError: error)
    }
    if let response = URLProtocolStub.response {
      client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    }
    client?.urlProtocolDidFinishLoading(self)
  }
}
