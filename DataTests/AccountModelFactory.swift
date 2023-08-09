import Domain
import Foundation

func makeAccountModel() -> AccountModel {
  AccountModel(
    id: "any_id",
    name: "any_name",
    email: "email@email.com",
    password: "any_password"
  )
}

func makeAddAccountModel() -> AddAccountModel {
  AddAccountModel(
    name: "any_name",
    email: "email@email.com",
    password: "any_password",
    passwordConfirmation: "any_password"
  )
}
