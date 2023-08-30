import Data
import Domain
import Foundation
import Infra

final class UseCaseFactory {
  static func makeRemoteAddAccount() -> AddAccount {
    let alamofireAdapter = AlamofireAdapter()
    let url = URL(string: "https://clean-node-api.herokuapp.com/api/signup")!
    return RemoteAddAccount(url: url, httpClient: alamofireAdapter)
  }

  static func makeRemoteGetSports(apiKey: String) -> GetSports {
    let alamofireAdapter = AlamofireAdapter()
    let url = URL(string: "https://api.the-odds-api.com/v4/sports?apiKey=\(apiKey)")!
    return RemoteGetSports(url: url, httpClient: alamofireAdapter)
  }
}
