import Domain
import Foundation

func makeSportModel() -> SportModel {
  SportModel(
    key: "any_key",
    group: "any_group",
    title: "any_title",
    active: true,
    description: "any_description",
    hasOutrights: true
  )
}
