import Foundation

func makeURL() -> URL {
  URL(string: "http://any-url.com")!
}

func makeInvalidData() -> Data {
  "invalid_data".data(using: .utf8)!
}

func makeValidData() -> Data {
  #"{"name":"Bruno"}"#.data(using: .utf8)!
}

func makeError() -> Error {
  NSError(domain: "any_error", code: 0)
}

func makeEmptyData() -> Data {
  Data()
}

func makeHTTPResponse(
  statusCode: Int = 200
) -> HTTPURLResponse {
  HTTPURLResponse(
    url: makeURL(),
    statusCode: statusCode,
    httpVersion: nil,
    headerFields: nil
  )!
}
