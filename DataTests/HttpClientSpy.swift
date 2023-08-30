import Data
import Foundation

final class HttpClientSpy: HttpPostClient, HttpGetClient {
  var data: Data?
  var urls = [URL]()
  var completion: ((Result<Data?, HttpError>) -> Void)?

  func get(
    from url: URL,
    completion: @escaping (Result<Data?, HttpError>) -> Void
  ) {
    self.urls.append(url)
    self.completion = completion
  }

  func post(
    to url: URL,
    with data: Data?,
    completion: @escaping (Result<Data?, HttpError>) -> Void
  ) {
    self.data = data
    self.urls.append(url)
    self.completion = completion
  }

  func completeWithData(_ data: Data) {
    completion?(.success(data))
  }

  func completeWithError(_ error: HttpError) {
    completion?(.failure(error))
  }
}
