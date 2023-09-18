import Foundation

public struct Outcome: Decodable {
  public var name: String
  public var price: Float
  public var point: Float?
  public var description: String?
}
