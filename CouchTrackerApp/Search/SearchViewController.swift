import CouchTrackerCore
import TraktSwift

final class SearchViewController: UIViewController, SearchResultOutput {
  @IBOutlet var searchViewContainer: UIView!
  @IBOutlet var collectionView: UICollectionView!
  @IBOutlet var infoLabel: UILabel!

  var imageRepository: ImageRepository!
  var searchView: SearchView!

  private var results = [SearchResult]()

  override func viewDidLoad() {
    super.viewDidLoad()

    guard imageRepository != nil else {
      Swift.fatalError("view loaded without imageRepository")
    }

    guard let searchView = searchView as? UIView else {
      Swift.fatalError("searchView should be an instance of UIView")
    }

    view.backgroundColor = Colors.View.background
    collectionView.backgroundColor = Colors.View.background

    collectionView.register(PosterAndTitleCell.self, forCellWithReuseIdentifier: PosterAndTitleCell.identifier)

    searchViewContainer.addSubview(searchView)
    collectionView.dataSource = self
  }

  func searchChangedTo(state _: SearchState) {}

  func handleEmptySearchResult() {
    infoLabel.text = "No results"
    collectionView.isHidden = true
    infoLabel.isHidden = false
  }

  func handleSearch(results: [SearchResult]) {
    self.results = results
    collectionView.reloadData()
    collectionView.isHidden = false
    infoLabel.isHidden = true
  }

  func handleError(message: String) {
    infoLabel.text = message
    collectionView.isHidden = true
    infoLabel.isHidden = false
  }
}

extension SearchViewController: UICollectionViewDataSource {
  func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
    return results.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = PosterAndTitleCell.identifier

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)

    guard let posterCell = cell as? PosterAndTitleCell else {
      Swift.fatalError("cell should be an instance of PosterAndTitleCell")
    }

    let result = results[indexPath.row]

    let viewModel: PosterViewModel

    switch result.type {
    case .movie:
      guard let movie = result.movie else { Swift.fatalError("Result type is movie, but there is no movie!") }
      viewModel = PosterMovieViewModelMapper.viewModel(for: movie)
    case .show:
      guard let show = result.show else { Swift.fatalError("Result type is show, but there is no show!") }
      viewModel = PosterShowViewModelMapper.viewModel(for: show)
    default:
      Swift.fatalError("Result type not implemented yet")
    }

    let interactor = PosterCellService(imageRepository: imageRepository)
    let presenter = PosterCellDefaultPresenter(view: posterCell, interactor: interactor, viewModel: viewModel)

    posterCell.presenter = presenter

    return cell
  }
}
