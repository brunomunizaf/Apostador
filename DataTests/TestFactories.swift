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
