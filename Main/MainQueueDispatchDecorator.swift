import Domain
import Foundation

public final class MainQueueDispatchDecorator<T> {
  private let instance: T

  public init(_ instance: T) {
    self.instance = instance
  }

  func dispatch(completion: @escaping () -> Void) {
    guard Thread.isMainThread else {
      return DispatchQueue.main.async(execute: completion)
    }
    completion()
  }
}

extension MainQueueDispatchDecorator: AddAccount where T: AddAccount {
  public func add(
    accountModel: AddAccountModel,
    completion: @escaping (Result<Account, Domain.DomainError>) -> Void
  ) {
    instance.add(accountModel: accountModel) { [weak self] result in
      self?.dispatch { completion(result) }
    }
  }
}
