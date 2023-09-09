import Data
import Domain
import Foundation
import Infra

final class UseCaseFactory {
  private static let httpClient = AlamofireAdapter()
  private static let apiBaseURL = Environment.variable(.apiBaseURL)

  private static func makeURL(path: String) -> URL {
    URL(string: "\(apiBaseURL)\(path)")!
  }

  static func makeRemoteAddAccount() -> AddAccount {
    MainQueueDispatchDecorator(
      RemoteAddAccount(
        url: URL(string: "https://clean-node-api.herokuapp.com/api/signup")!,
        httpClient: httpClient
      )
    )
  }

  static func makeRemoteGetSports(apiKey: String) -> GetSports {
    RemoteGetSports(
      url: makeURL(path: "/sports?apiKey=\(apiKey)"),
      httpClient: httpClient
    )
  }
}
