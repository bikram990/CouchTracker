import RxSwift

public final class TraktLoginDefaultPresenter: TraktLoginPresenter {
	private weak var view: TraktLoginView?
	private let interactor: TraktLoginInteractor
	private let output: TraktLoginOutput
	private let disposeBag = DisposeBag()

	public init(view: TraktLoginView, interactor: TraktLoginInteractor, output: TraktLoginOutput) {
		self.view = view
		self.interactor = interactor
		self.output = output
	}

	public func viewDidLoad() {
		interactor.fetchLoginURL()
			.observeOn(MainScheduler.instance)
			.subscribe(onSuccess: { [unowned self] url in
				guard let view = self.view else { return }
				view.loadLogin(using: url)
				}, onError: { [unowned self] error in
					self.output.logInFail(message: error.localizedDescription)
			}).disposed(by: disposeBag)
	}
}