// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// MARK: - EnumClosures

public extension SyncError {
    public func onShowIsNil(_ fn: () -> Void) {
        guard case .showIsNil = self else { return }
        fn()
    }
    public func onMissingEpisodes(_ fn: (ShowIds, BaseSeason, Season) -> Void) {
        guard case let .missingEpisodes(showIds, baseSeason, season) = self else { return }
        fn(showIds, baseSeason, season)
    }
}
