import Domain

final class GetSportsSpy: GetSports {
  var completion: ((Result<[SportModel], DomainError>) -> Void)?

  func get(completion: @escaping (Result<[SportModel], DomainError>) -> Void) {
    self.completion = completion
  }

  func completeWithError(_ error: DomainError) {
    completion?(.failure(error))
  }

  func completeWithSports(_ models: [SportModel]) {
    completion?(.success(models))
  }
}
