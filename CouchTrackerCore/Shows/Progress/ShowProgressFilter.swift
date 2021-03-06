import TraktSwift

public enum ShowProgressFilter: String {
  case none
  case watched
  case returning
  case returningWatched

  public static func create(from value: String?) -> ShowProgressFilter {
    guard let stringValue = value else { return ShowProgressFilter.none }
    return ShowProgressFilter(rawValue: stringValue) ?? ShowProgressFilter.none
  }

  public static func allValues() -> [ShowProgressFilter] {
    return [.none, .watched, .returning, returningWatched]
  }

  public static func filter(for index: Int) -> ShowProgressFilter {
    let allValues = ShowProgressFilter.allValues()
    if index < 0 || index >= allValues.count {
      return ShowProgressFilter.none
    }

    return allValues[index]
  }

  public func index() -> Int {
    return ShowProgressFilter.allValues().firstIndex(of: self) ?? 0
  }

  public func filter() -> (WatchedShowEntity) -> Bool {
    if self == .none { return filterNone() }
    if self == .watched { return filterWatched() }
    if self == .returning { return filterReturning() }
    return filterReturningWatched()
  }

  private func filterNone() -> (WatchedShowEntity) -> Bool {
    return { (_: WatchedShowEntity) in true }
  }

  private func filterWatched() -> (WatchedShowEntity) -> Bool {
    return { (entity: WatchedShowEntity) in (entity.aired ?? -1) - (entity.completed ?? -1) > 0 }
  }

  private func filterReturning() -> (WatchedShowEntity) -> Bool {
    return { (entity: WatchedShowEntity) in entity.show.status == Status.returning }
  }

  private func filterReturningWatched() -> (WatchedShowEntity) -> Bool {
    return { (entity: WatchedShowEntity) in
      (entity.aired ?? -1) - (entity.completed ?? -1) > 0 || entity.show.status == Status.returning
    }
  }
}
