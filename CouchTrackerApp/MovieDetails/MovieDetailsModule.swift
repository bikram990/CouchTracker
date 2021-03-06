import CouchTrackerCore
import TraktSwift

public final class MovieDetailsModule {
  private init() {}

  public static func setupModule(movieIds: MovieIds) -> BaseView {
    let trakt = Environment.instance.trakt
    let schedulers = Environment.instance.schedulers
    let appStateManager = Environment.instance.appStateManager
    let genreRepository = Environment.instance.genreRepository
    let imageRespository = Environment.instance.imageRepository

    let repository = MovieDetailsAPIRepository(traktProvider: trakt, schedulers: schedulers)

    let interactor = MovieDetailsService(repository: repository, genreRepository: genreRepository,
                                         imageRepository: imageRespository, movieIds: movieIds)

    let presenter = MovieDetailsDefaultPresenter(interactor: interactor, appStateObservable: appStateManager)

    return MovieDetailsViewController(presenter: presenter)
  }
}
