import Foundation

public protocol GetSports {
  func get(
    completion: @escaping (Result<[SportModel], DomainError>) -> Void
  )
}
