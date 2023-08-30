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
}
