import Foundation

public enum HttpError: Error {
  case forbidden
  case badRequest
  case serverError
  case unauthorized
  case noConnectivityError
}
