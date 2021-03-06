import RxSwift
import TraktSwift

public protocol MovieDetailsPresenter: AnyObject {
  func viewDidLoad()

  func observeViewState() -> Observable<MovieDetailsViewState>
  func observeImagesState() -> Observable<MovieDetailsImagesState>
  func handleWatched() -> Completable
}

public protocol MovieDetailsInteractor: AnyObject {
  func fetchDetails() -> Observable<MovieEntity>
  func fetchImages() -> Maybe<ImagesEntity>
  func toggleWatched(movie: MovieEntity) -> Completable
}

public protocol MovieDetailsRepository: AnyObject {
  func fetchDetails(movieId: String) -> Observable<Movie>
  func watched(movieId: Int) -> Single<WatchedMovieResult>
  func addToHistory(movie: MovieEntity) -> Single<SyncMovieResult>
  func removeFromHistory(movie: MovieEntity) -> Single<SyncMovieResult>
}
