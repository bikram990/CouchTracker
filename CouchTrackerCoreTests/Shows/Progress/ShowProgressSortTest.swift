@testable import CouchTrackerCore
import TraktSwift
import XCTest

final class ShowProgressSortTest: XCTestCase {
  func testShowProgressSort_returnAllValues() {
    XCTAssertEqual(ShowProgressSort.allValues(), [ShowProgressSort.title, ShowProgressSort.remaining, ShowProgressSort.lastWatched, ShowProgressSort.releaseDate])
  }

  func testShowProgressSort_returnsSortForIndex() {
    XCTAssertEqual(ShowProgressSort.sort(for: 0), ShowProgressSort.title)
    XCTAssertEqual(ShowProgressSort.sort(for: 1), ShowProgressSort.remaining)
    XCTAssertEqual(ShowProgressSort.sort(for: 2), ShowProgressSort.lastWatched)
    XCTAssertEqual(ShowProgressSort.sort(for: 3), ShowProgressSort.releaseDate)
    XCTAssertEqual(ShowProgressSort.sort(for: -1), ShowProgressSort.title)
    XCTAssertEqual(ShowProgressSort.sort(for: 4), ShowProgressSort.title)
  }

  func testShowProgressSort_returnsIndexForSort() {
    XCTAssertEqual(ShowProgressSort.title.index(), 0)
    XCTAssertEqual(ShowProgressSort.remaining.index(), 1)
    XCTAssertEqual(ShowProgressSort.lastWatched.index(), 2)
    XCTAssertEqual(ShowProgressSort.releaseDate.index(), 3)
  }

  func testShowProgressSort_titleComparator() {
    // Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let ids = mock.show.ids
    let seasons = [WatchedSeasonEntity]()

    let genres = [Genre]()

    let showA = ShowEntity(ids: ids, title: "A", overview: nil, network: nil, genres: genres, status: nil, firstAired: nil)
    let showB = ShowEntity(ids: ids, title: "b", overview: nil, network: nil, genres: genres, status: nil, firstAired: nil)
    let showNil = ShowEntity(ids: ids, title: nil, overview: nil, network: nil, genres: genres, status: nil, firstAired: nil)

    let watchedShowA = WatchedShowEntity(show: showA, aired: 0, completed: 0, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let watchedShowB = WatchedShowEntity(show: showB, aired: 0, completed: 0, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let watchedShowNil = WatchedShowEntity(show: showNil, aired: 0, completed: 0, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let shows = [watchedShowB, watchedShowNil, watchedShowA]

    // When
    let comparator = ShowProgressSort.title.comparator()
    let sortedShows = shows.sorted(by: comparator)

    // Then
    let expectedShows = [watchedShowNil, watchedShowA, watchedShowB]

    XCTAssertEqual(sortedShows, expectedShows)
  }

  func testShowProgressSort_remainingComparator() {
    // Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let show = mock.show
    let seasons = [WatchedSeasonEntity]()

    let watchedShow1 = WatchedShowEntity(show: show, aired: 10, completed: 10, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let watchedShow2 = WatchedShowEntity(show: show, aired: 10, completed: 5, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let watchedShow3 = WatchedShowEntity(show: show, aired: 3, completed: 1, nextEpisode: nil, lastWatched: nil, seasons: seasons)

    let shows = [watchedShow2, watchedShow1, watchedShow3]

    // When
    let comparator = ShowProgressSort.remaining.comparator()
    let sortedShows = shows.sorted(by: comparator)

    // Then
    let expectedShows = [watchedShow1, watchedShow3, watchedShow2]

    XCTAssertEqual(sortedShows, expectedShows)
  }

  func testShowProgressSort_lastWatchedComparator() {
    // Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let show = mock.show
    let seasons = [WatchedSeasonEntity]()

    let date1 = Date(timeIntervalSince1970: 1)
    let date2 = Date(timeIntervalSince1970: 10)
    let date3: Date? = nil

    let watchedShow1 = WatchedShowEntity(show: show, aired: 10, completed: 10, nextEpisode: nil, lastWatched: date1, seasons: seasons)

    let watchedShow2 = WatchedShowEntity(show: show, aired: 10, completed: 5, nextEpisode: nil, lastWatched: date2, seasons: seasons)

    let watchedShow3 = WatchedShowEntity(show: show, aired: 3, completed: 1, nextEpisode: nil, lastWatched: date3, seasons: seasons)

    let watchedShow4 = WatchedShowEntity(show: show, aired: 3, completed: 3, nextEpisode: nil, lastWatched: date3, seasons: seasons)

    let shows = [watchedShow2, watchedShow4, watchedShow1, watchedShow3]

    // When
    let comparator = ShowProgressSort.lastWatched.comparator()
    let sortedShows = shows.sorted(by: comparator)

    // Then
    let expectedShows = [watchedShow2, watchedShow1, watchedShow4, watchedShow3]

    XCTAssertEqual(sortedShows, expectedShows)
  }

  func testShowProgressSort_nextEpisodeDateComparator() {
    // Given
    let mock = ShowsProgressMocks.mockWatchedShowEntity()
    let episodeMock = ShowsProgressMocks.mockEpisodeEntity()
    let show = mock.show
    let showIds = show.ids
    let episodeIds = episodeMock.ids
    let seasons = [WatchedSeasonEntity]()

    let date1 = Date(timeIntervalSince1970: 1)
    let date2 = Date(timeIntervalSince1970: 10)
    let date3: Date? = nil

    let episodeEntityAired = { date in
      EpisodeEntity(ids: episodeIds,
                    showIds: showIds,
                    title: "",
                    overview: nil,
                    number: 0,
                    season: 0,
                    firstAired: date,
                    absoluteNumber: 1)
    }

    let episode1 = episodeEntityAired(date1)
    let episode2 = episodeEntityAired(date2)
    let episode3 = episodeEntityAired(date3)
    let episode4 = episodeEntityAired(date3)

    let watchedEpisode = { episode in
      WatchedEpisodeEntity(episode: episode, lastWatched: nil)
    }

    let nextEpisode1 = watchedEpisode(episode1)
    let nextEpisode2 = watchedEpisode(episode2)
    let nextEpisode3 = watchedEpisode(episode3)
    let nextEpisode4 = watchedEpisode(episode4)

    let watchedShow = { nextEpisode, lastWatched in
      WatchedShowEntity(show: show,
                        aired: 10,
                        completed: 10,
                        nextEpisode: nextEpisode,
                        lastWatched: lastWatched,
                        seasons: seasons)
    }

    let watchedShow1 = watchedShow(nextEpisode1, date1)
    let watchedShow2 = watchedShow(nextEpisode2, date2)
    let watchedShow3 = watchedShow(nextEpisode3, date3)
    let watchedShow4 = watchedShow(nextEpisode4, date3)

    let shows = [watchedShow2, watchedShow4, watchedShow1, watchedShow3]

    // When
    let comparator = ShowProgressSort.releaseDate.comparator()
    let sortedShows = shows.sorted(by: comparator)

    // Then
    let expectedShows = [watchedShow2, watchedShow1, watchedShow4, watchedShow3]

    XCTAssertEqual(sortedShows, expectedShows)
  }
}
