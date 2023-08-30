import Domain
import Presentation
import XCTest

final class SportsListPresenterTests: XCTestCase {
  func test_fetchShouldShowErrorMessageIfGetSportsFail() {
    let alertViewSpy = AlertViewSpy()
    let getSportsSpy = GetSportsSpy()
    let sut = makeSUT(
      alertView: alertViewSpy,
      getSports: getSportsSpy
    )
    let exp = expectation(description: "waiting")
    alertViewSpy.observe {
      XCTAssertEqual($0, makeErrorAlertViewModel(
        message: "Algo inesperado aconteceu, tente novamente em instantes.")
      )
      exp.fulfill()
    }

    sut.fetch()
    getSportsSpy.completeWithError(.unexpected)
    wait(for: [exp], timeout: 1)
  }

  func test_fetchShouldShowErrorMessageIfGetSportsDecodingFails() {
    let alertViewSpy = AlertViewSpy()
    let getSportsSpy = GetSportsSpy()
    let sut = makeSUT(
      alertView: alertViewSpy,
      getSports: getSportsSpy
    )
    let exp = expectation(description: "waiting")
    alertViewSpy.observe {
      XCTAssertEqual($0, makeErrorAlertViewModel(
        message: "Algo inesperado aconteceu, tente novamente em instantes.")
      )
      exp.fulfill()
    }

    sut.fetch()
    getSportsSpy.completeWithError(.decodeFailure)
    wait(for: [exp], timeout: 1)
  }

  func test_fetchShouldShowLoadingBeforeAndAfterCallGetSports() {
    let getSportsSpy = GetSportsSpy()
    let loadingViewSpy = LoadingViewSpy()
    let sut = makeSUT(
      getSports: getSportsSpy,
      loadingView: loadingViewSpy
    )
    let exp = expectation(description: "waiting")
    loadingViewSpy.observe { viewModel in
      XCTAssertEqual(
        viewModel,
        LoadingViewModel(isLoading: true)
      )
      exp.fulfill()
    }
    sut.fetch()
    wait(for: [exp], timeout: 1)
    let exp2 = expectation(description: "waiting")
    loadingViewSpy.observe { viewModel in
      XCTAssertEqual(
        viewModel,
        LoadingViewModel(isLoading: false)
      )
      exp2.fulfill()
    }
    getSportsSpy.completeWithError(.unexpected)
    wait(for: [exp2], timeout: 1)
  }
}

extension SportsListPresenterTests {
  func makeSUT(
    alertView: AlertViewSpy = .init(),
    getSports: GetSportsSpy = .init(),
    loadingView: LoadingViewSpy = .init()
  ) -> SportsListPresenter {
    let sut = SportsListPresenter(
      alertView: alertView,
      getSports: getSports,
      loadingView: loadingView
    )
    addTeardownBlock { [weak sut] in
      XCTAssertNil(sut)
    }
    return sut
  }
}
