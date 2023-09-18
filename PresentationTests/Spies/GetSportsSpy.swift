import Domain

final class GetSportsSpy: GetSports {
  var completion: ((Result<[Sport], DomainError>) -> Void)?

  func get(completion: @escaping (Result<[Sport], DomainError>) -> Void) {
    self.completion = completion
  }

  func completeWithError(_ error: DomainError) {
    completion?(.failure(error))
  }

  func completeWithSports(_ models: [Sport]) {
    completion?(.success(models))
  }
}
