import Alamofire
import Data
import Foundation

public final class AlamofireAdapter: HttpPostClient, HttpGetClient {
  private let session: Session

  public init(session: Session = .default) {
    self.session = session
  }

  public func get(
    from url: URL,
    completion: @escaping (Result<Data?, HttpError>) -> Void
  ) {
    print(">>> Will perform URL request to:")
    print(url.absoluteString)
    print("------------------------------")

    session
      .request(
        url,
        method: .get
      )
      .responseData { dataResponse in
        guard let statusCode = dataResponse.response?.statusCode else {
          completion(.failure(.noConnectivityError))
          return
        }
        switch dataResponse.result {
        case .failure:
          completion(.failure(.noConnectivityError))

        case .success(let data):
          switch statusCode {
          case 204:
            completion(.success(nil))
          case 200...299:
            completion(.success(data))
          case 401:
            completion(.failure(.unauthorized))
          case 403:
            completion(.failure(.forbidden))
          case 400...499:
            completion(.failure(.badRequest))
          case 500...599:
            completion(.failure(.serverError))
          default:
            completion(.failure(.noConnectivityError))
          }

          print(">>> Did receive URL response:")
          print(String(data: data, encoding: .utf8)!)
          print("------------------------------")
        }
      }
  }

  public func post(
    to url: URL,
    with data: Data?,
    completion: @escaping (Result<Data?, HttpError>) -> Void
  ) {
    session
      .request(
        url,
        method: .post,
        parameters: data?.toJSON(),
        encoding: JSONEncoding.default
      )
      .responseData { dataResponse in
        guard let statusCode = dataResponse.response?.statusCode else {
          completion(.failure(.noConnectivityError))
          return
        }
        switch dataResponse.result {
        case .failure(_):
          completion(.failure(.noConnectivityError))

        case .success(let data):
          switch statusCode {
          case 204:
            completion(.success(nil))
          case 200...299:
            completion(.success(data))
          case 401:
            completion(.failure(.unauthorized))
          case 403:
            completion(.failure(.forbidden))
          case 400...499:
            completion(.failure(.badRequest))
          case 500...599:
            completion(.failure(.serverError))
          default:
            completion(.failure(.noConnectivityError))
          }
        }
      }
  }
}
