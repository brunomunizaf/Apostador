public struct Sport: Model {
  public var key: String
  public var group: String
  public var title: String
  public var active: Bool
  public var description: String
  public var hasOutrights: Bool

  public init(
    key: String,
    group: String,
    title: String,
    active: Bool,
    description: String,
    hasOutrights: Bool
  ) {
    self.key = key
    self.group = group
    self.title = title
    self.active = active
    self.description = description
    self.hasOutrights = hasOutrights
  }
}
