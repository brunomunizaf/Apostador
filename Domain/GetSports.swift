public protocol GetSports {
  func get(completion: @escaping (Result<[Sport], DomainError>) -> Void)
}
