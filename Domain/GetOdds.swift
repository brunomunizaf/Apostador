public protocol GetOdds {
  func get(completion: @escaping (Result<[Odd], DomainError>) -> Void)
}
