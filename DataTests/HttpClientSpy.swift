import Data
import Foundation

final class HttpClientSpy: HttpPostClient {
  var data: Data?
  var urls = [URL]()
  var completion: ((Result<Data?, HttpError>) -> Void)?

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
